import { Response, NextFunction } from 'express';
import { AuthRequest } from '../../middleware/auth.middleware';
export declare class InterestsController {
    static express(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static list(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static acceptOrReject(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static myInterests(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
}
//# sourceMappingURL=interests.controller.d.ts.map