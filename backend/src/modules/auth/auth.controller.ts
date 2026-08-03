import { Request, Response, NextFunction } from 'express';
import { AuthService } from './auth.service';
import { sendSuccess } from '../../utils/api-response';
import { AuthRequest } from '../../middleware/auth.middleware';

export class AuthController {
  static async sendOtp(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await AuthService.sendOtp(req.body.phone);
      sendSuccess(res, result);
    } catch (err) {
      next(err);
    }
  }

  static async verifyOtp(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await AuthService.verifyOtp(req.body.phone, req.body.otp);
      sendSuccess(res, result);
    } catch (err) {
      next(err);
    }
  }

  static async refresh(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await AuthService.refreshToken(req.body.refreshToken);
      sendSuccess(res, result);
    } catch (err) {
      next(err);
    }
  }

  static async selectRole(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await AuthService.selectRole(req.userId!, req.body.role);
      sendSuccess(res, result);
    } catch (err) {
      next(err);
    }
  }
}
