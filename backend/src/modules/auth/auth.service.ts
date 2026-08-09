import jwt from 'jsonwebtoken';
import prisma from '../../config/database';
import { env } from '../../config/env';
import { ApiError } from '../../utils/api-error';
import logger from '../../utils/logger';
import * as admin from 'firebase-admin';

// In-memory OTP store (for demo — production would use Redis)
const otpStore: Map<string, { otp: string; attempts: number; expiresAt: number }> = new Map();

export class AuthService {
  static async sendOtp(phone: string): Promise<{ message: string }> {
    // Rate limit: check if OTP was sent recently
    const existing = otpStore.get(phone);
    if (existing && existing.expiresAt > Date.now() && existing.attempts === 0) {
      const waitSeconds = Math.ceil((existing.expiresAt - Date.now()) / 1000);
      throw new ApiError(429, 'OTP_RATE_LIMITED', `Please wait ${waitSeconds} seconds before requesting a new OTP.`);
    }

    // Generate OTP (mock: always 123456 for demo)
    const otp = env.MOCK_OTP;
    otpStore.set(phone, {
      otp,
      attempts: 0,
      expiresAt: Date.now() + 5 * 60 * 1000, // 5 minutes
    });

    logger.info('OTP sent', { phone, otp });
    return { message: 'OTP sent successfully.' };
  }

  static async verifyOtp(phone: string, otp: string): Promise<{
    accessToken: string;
    refreshToken: string;
    user: { id: string; phone: string; role: string | null; name: string | null; isNewUser: boolean };
  }> {
    const stored = otpStore.get(phone);

    if (!stored || stored.expiresAt < Date.now()) {
      throw new ApiError(400, 'OTP_EXPIRED', 'OTP has expired. Please request a new one.');
    }

    if (stored.attempts >= 3) {
      otpStore.delete(phone);
      throw new ApiError(400, 'OTP_MAX_ATTEMPTS', 'Maximum OTP attempts reached. Please request a new OTP.');
    }

    if (stored.otp !== otp) {
      stored.attempts += 1;
      throw new ApiError(400, 'OTP_INVALID', 'Invalid OTP. Please try again.');
    }

    // OTP verified — delete from store
    otpStore.delete(phone);

    // Find or create user
    let user = await prisma.user.findUnique({ where: { phone } });
    let isNewUser = false;

    if (!user) {
      user = await prisma.user.create({ data: { phone } });
      isNewUser = true;
    }

    // Generate tokens
    const accessToken = jwt.sign(
      { userId: user.id, role: user.role },
      env.JWT_SECRET,
      { expiresIn: env.JWT_EXPIRY as string }
    );

    const refreshToken = jwt.sign(
      { userId: user.id },
      env.JWT_REFRESH_SECRET,
      { expiresIn: env.JWT_REFRESH_EXPIRY as string }
    );

    return {
      accessToken,
      refreshToken,
      user: { id: user.id, phone: user.phone, role: user.role, name: user.name, isNewUser },
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
        { expiresIn: env.JWT_EXPIRY as string }
      );

      const refreshToken = jwt.sign(
        { userId: user.id },
        env.JWT_REFRESH_SECRET,
        { expiresIn: env.JWT_REFRESH_EXPIRY as string }
      );

      return { accessToken, refreshToken };
    } catch {
      throw new ApiError(401, 'REFRESH_INVALID', 'Invalid refresh token.');
    }
  }

  static async verifyFirebase(idToken: string): Promise<{
    accessToken: string;
    refreshToken: string;
    user: { id: string; phone: string; role: string | null; name: string | null; isNewUser: boolean };
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
        user = await prisma.user.create({ data: { phone } });
        isNewUser = true;
      }

      const accessToken = jwt.sign(
        { userId: user.id, role: user.role },
        env.JWT_SECRET,
        { expiresIn: env.JWT_EXPIRY as string }
      );

      const refreshToken = jwt.sign(
        { userId: user.id },
        env.JWT_REFRESH_SECRET,
        { expiresIn: env.JWT_REFRESH_EXPIRY as string }
      );

      return {
        accessToken,
        refreshToken,
        user: { id: user.id, phone: user.phone, role: user.role, name: user.name, isNewUser },
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
      { expiresIn: env.JWT_EXPIRY as string }
    );

    return { user, accessToken };
  }
}
