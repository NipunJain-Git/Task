import { Response, NextFunction } from 'express';
import { AuthRequest } from '../../middleware/auth.middleware';
export declare class UsersController {
    static getMe(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static updateProfile(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static updateWorkerProfile(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static updateHouseholdProfile(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static toggleAvailability(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static getUserById(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static getRatingSummary(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static updateFcmToken(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static updateLocation(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static submitKyc(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
}
//# sourceMappingURL=users.controller.d.ts.map