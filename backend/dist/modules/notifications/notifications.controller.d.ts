import { Response, NextFunction } from 'express';
import { AuthRequest } from '../../middleware/auth.middleware';
export declare class NotificationsController {
    static list(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static markRead(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static unreadCount(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
}
//# sourceMappingURL=notifications.controller.d.ts.map