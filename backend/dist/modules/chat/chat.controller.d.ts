import { Response, NextFunction } from 'express';
import { AuthRequest } from '../../middleware/auth.middleware';
export declare class ChatController {
    static getMessages(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static sendMessage(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static getInbox(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
}
//# sourceMappingURL=chat.controller.d.ts.map