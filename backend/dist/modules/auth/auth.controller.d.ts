import { Request, Response, NextFunction } from 'express';
import { AuthRequest } from '../../middleware/auth.middleware';
export declare class AuthController {
    static sendOtp(req: Request, res: Response, next: NextFunction): Promise<void>;
    static verifyOtp(req: Request, res: Response, next: NextFunction): Promise<void>;
    static verifyFirebase(req: Request, res: Response, next: NextFunction): Promise<void>;
    static refresh(req: Request, res: Response, next: NextFunction): Promise<void>;
    static selectRole(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
}
//# sourceMappingURL=auth.controller.d.ts.map