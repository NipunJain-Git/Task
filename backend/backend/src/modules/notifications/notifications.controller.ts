import { Response, NextFunction } from 'express';
import { NotificationsService } from './notifications.service';
import { sendSuccess } from '../../utils/api-response';
import { AuthRequest } from '../../middleware/auth.middleware';

export class NotificationsController {
  static async list(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await NotificationsService.list(req.userId!);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async markRead(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      await NotificationsService.markRead(req.params.id, req.userId!);
      sendSuccess(res, { success: true });
    } catch (err) { next(err); }
  }

  static async unreadCount(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const count = await NotificationsService.getUnreadCount(req.userId!);
      sendSuccess(res, { count });
    } catch (err) { next(err); }
  }
}
