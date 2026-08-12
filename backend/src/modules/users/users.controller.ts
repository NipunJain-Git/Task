import { Response, NextFunction } from 'express';
import { UsersService } from './users.service';
import { sendSuccess } from '../../utils/api-response';
import { AuthRequest } from '../../middleware/auth.middleware';
import prisma from '../../config/database';

export class UsersController {
  static async getMe(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UsersService.getMe(req.userId!);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async updateProfile(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UsersService.updateProfile(req.userId!, req.body);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async updateWorkerProfile(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UsersService.updateWorkerProfile(req.userId!, req.body);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async updateHouseholdProfile(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UsersService.updateHouseholdProfile(req.userId!, req.body);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async toggleAvailability(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UsersService.toggleAvailability(req.userId!, req.body.isAvailable);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async getUserById(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UsersService.getUserById(req.params.id);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async getRatingSummary(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UsersService.getRatingSummary(req.params.id);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async updateFcmToken(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      await prisma.user.update({
        where: { id: req.userId! },
        data: { fcmToken: req.body.fcmToken },
      });
      sendSuccess(res, { message: 'FCM token updated' });
    } catch (err) { next(err); }
  }

  static async updateLocation(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      await prisma.user.update({
        where: { id: req.userId! },
        data: { latitude: req.body.latitude, longitude: req.body.longitude },
      });
      sendSuccess(res, { message: 'Location updated' });
    } catch (err) { next(err); }
  }

  static async submitKyc(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const { identityNumber } = req.body;
      if (!identityNumber || !/^\d{12}$/.test(identityNumber)) {
        res.status(400).json({ success: false, message: 'Invalid identity number' });
        return;
      }
      await prisma.user.update({
        where: { id: req.userId! },
        data: { 
          kycStatus: 'PENDING',
          identityNumber,
        },
      });
      sendSuccess(res, { message: 'KYC submitted successfully', kycStatus: 'PENDING' });
    } catch (err) { next(err); }
  }
}
