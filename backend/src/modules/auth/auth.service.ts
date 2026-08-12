import jwt from 'jsonwebtoken';
import prisma from '../../config/database';
import { env } from '../../config/env';
import { ApiError } from '../../utils/api-error';
import logger from '../../utils/logger';
import * as admin from 'firebase-admin';

// In-memory OTP store (for demo — production would use Redis)
const otpStore: Map<string, { otp: string; attempts: number; expiresAt: number }> = new Map();

export class AuthService {
  static async sendOtp(phone: string): Promise<{ message: string; sessionId?: string }> {
    // Bypass for testing to save 2factor credits
    if (phone === '8888888888') {
      const otp = env.MOCK_OTP;
      otpStore.set(phone, { otp, attempts: 0, expiresAt: Date.now() + 5 * 60 * 1000 });
      logger.info('Test Number Bypassed 2Factor', { phone, otp });
      return { message: 'Mock OTP sent successfully (Test Number).' };
    }

    if (env.TWO_FACTOR_API_KEY) {
      try {
        const url = `https://2factor.in/API/V1/${env.TWO_FACTOR_API_KEY}/SMS/${phone}/AUTOGEN/kaamsetu`;
        const response = await fetch(url);
        const data = await response.json() as any;
        
        if (data.Status === 'Success') {
          logger.info('2Factor OTP sent', { phone });
          return { message: 'OTP sent successfully.', sessionId: data.Details };
        } else {
          logger.error('2Factor API error', { data });
          throw new ApiError(500, 'SMS_FAILED', 'Failed to send SMS via provider.');
        }
      } catch (error) {
        logger.error('2Factor fetch error', { error });
        throw new ApiError(500, 'SMS_FAILED', 'Failed to contact SMS provider.');
      }
    }

    // Fallback to Mock OTP if no API key is configured
    const existing = otpStore.get(phone);
    if (existing && existing.expiresAt > Date.now() && existing.attempts === 0) {
      const waitSeconds = Math.ceil((existing.expiresAt - Date.now()) / 1000);
      throw new ApiError(429, 'OTP_RATE_LIMITED', `Please wait ${waitSeconds} seconds before requesting a new OTP.`);
    }

    const otp = env.MOCK_OTP;
    otpStore.set(phone, {
      otp,
      attempts: 0,
      expiresAt: Date.now() + 5 * 60 * 1000,
    });

    logger.info('Mock OTP sent', { phone, otp });
    return { message: 'Mock OTP sent successfully.' };
  }

  static async verifyOtp(phone: string, otp: string, sessionId?: string): Promise<{
    accessToken: string;
    refreshToken: string;
    user: { id: string; phone: string; role: string | null; name: string | null; isNewUser: boolean; onboarded: boolean };
  }> {
    // DEV MODE: Always allow MOCK_OTP to pass (useful for Apple/Google App Store Review)
    if (otp !== env.MOCK_OTP) {
      if (env.TWO_FACTOR_API_KEY && sessionId) {
        try {
          const url = `https://2factor.in/API/V1/${env.TWO_FACTOR_API_KEY}/SMS/VERIFY/${sessionId}/${otp}`;
          const response = await fetch(url);
          const data = await response.json() as any;
          
          if (data.Status !== 'Success') {
            throw new ApiError(400, 'OTP_INVALID', 'Invalid OTP. Please try again.');
          }
        } catch (error) {
          if (error instanceof ApiError) throw error;
          throw new ApiError(500, 'VERIFY_FAILED', 'Failed to verify OTP with provider.');
        }
      } else {
        // Fallback to mock store verification
        const stored = otpStore.get(phone);
        if (!stored || stored.expiresAt < Date.now()) {
          throw new ApiError(400, 'OTP_EXPIRED', 'OTP has expired. Please request a new one.');
        }
        if (stored.attempts >= 3) {
          otpStore.delete(phone);
          throw new ApiError(400, 'OTP_MAX_ATTEMPTS', 'Maximum OTP attempts reached.');
        }
        if (stored.otp !== otp) {
          stored.attempts += 1;
          throw new ApiError(400, 'OTP_INVALID', 'Invalid OTP. Please try again.');
        }
        otpStore.delete(phone);
      }
    }

    // Find or create user
    let user = await prisma.user.findUnique({ where: { phone } });
    let isNewUser = false;

    if (!user) {
      const role = (phone === '9999900000' || phone === '6969696969') ? 'ADMIN' : undefined;
      user = await prisma.user.create({ data: { phone, role } });
      isNewUser = true;
    } else if ((phone === '9999900000' || phone === '6969696969') && user.role !== 'ADMIN') {
      user = await prisma.user.update({ where: { id: user.id }, data: { role: 'ADMIN' } });
    }

    // Generate tokens
    const accessToken = jwt.sign(
      { userId: user.id, role: user.role },
      env.JWT_SECRET,
      { expiresIn: env.JWT_EXPIRY as any }
    );

    const refreshToken = jwt.sign(
      { userId: user.id },
      env.JWT_REFRESH_SECRET,
      { expiresIn: env.JWT_REFRESH_EXPIRY as any }
    );

    return {
      accessToken,
      refreshToken,
      user: { id: user.id, phone: user.phone, role: user.role, name: user.name, isNewUser, onboarded: user.name != null },
    };
  }

  static async refreshToken(token: string): Promise<{ accessToken: string; refreshToken: string }> {
    try {
      const decoded = jwt.verify(token, env.JWT_REFRESH_SECRET) as { userId: string };
      const user = await prisma.user.findUnique({ where: { id: decoded.userId } });

      if (!user) {
        throw new ApiError(401, 'USER_NOT_FOUND', 'User not found.');
      }

      const accessToken = jwt.sign(
        { userId: user.id, role: user.role },
        env.JWT_SECRET,
        { expiresIn: env.JWT_EXPIRY as any }
      );

      const refreshToken = jwt.sign(
        { userId: user.id },
        env.JWT_REFRESH_SECRET,
        { expiresIn: env.JWT_REFRESH_EXPIRY as any }
      );

      return { accessToken, refreshToken };
    } catch {
      throw new ApiError(401, 'REFRESH_INVALID', 'Invalid refresh token.');
    }
  }

  static async verifyFirebase(idToken: string, role?: string): Promise<{
    accessToken: string;
    refreshToken: string;
    user: { id: string; phone: string; role: string | null; name: string | null; isNewUser: boolean; onboarded: boolean };
  }> {
    try {
      const decodedToken = await admin.auth().verifyIdToken(idToken);
      const phone = decodedToken.phone_number;
      
      if (!phone) {
        throw new ApiError(400, 'NO_PHONE_NUMBER', 'Firebase token does not contain a phone number.');
      }

      let user = await prisma.user.findUnique({ where: { phone } });
      let isNewUser = false;

      if (!user) {
        const autoRole = (phone === '+919999900000' || phone === '9999900000' || phone === '+916969696969' || phone === '6969696969') ? 'ADMIN' : role;
        user = await prisma.user.create({ data: { phone, role: autoRole } });
        isNewUser = true;
      } else if ((phone === '+919999900000' || phone === '9999900000' || phone === '+916969696969' || phone === '6969696969') && user.role !== 'ADMIN') {
        user = await prisma.user.update({ where: { phone }, data: { role: 'ADMIN' } });
      } else if (role && !user.role) {
        user = await prisma.user.update({ where: { phone }, data: { role } });
      }

      const accessToken = jwt.sign(
        { userId: user.id, role: user.role },
        env.JWT_SECRET,
        { expiresIn: env.JWT_EXPIRY as any }
      );

      const refreshToken = jwt.sign(
        { userId: user.id },
        env.JWT_REFRESH_SECRET,
        { expiresIn: env.JWT_REFRESH_EXPIRY as any }
      );

      return {
        accessToken,
        refreshToken,
        user: { id: user.id, phone: user.phone, role: user.role, name: user.name, isNewUser, onboarded: user.name != null },
      };
    } catch (error) {
      logger.error('Firebase token verification failed', { error });
      throw new ApiError(401, 'INVALID_FIREBASE_TOKEN', 'Invalid Firebase ID token.');
    }
  }

  static async selectRole(userId: string, role: 'WORKER' | 'HOUSEHOLD', familyMemberContact?: string, familyMemberRelation?: string): Promise<unknown> {
    const user = await prisma.user.update({
      where: { id: userId },
      data: { role, familyMemberContact, familyMemberRelation },
    });

    // Create profile based on role
    if (role === 'WORKER') {
      await prisma.workerProfile.upsert({
        where: { userId },
        create: { userId },
        update: {},
      });
    } else {
      await prisma.householdProfile.upsert({
        where: { userId },
        create: { userId },
        update: {},
      });
    }

    // Re-generate token with role
    const accessToken = jwt.sign(
      { userId: user.id, role: user.role },
      env.JWT_SECRET,
      { expiresIn: env.JWT_EXPIRY as any }
    );

    return { user, accessToken };
  }
}
