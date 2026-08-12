import { Response, NextFunction } from 'express';
import { AuthRequest } from '../../middleware/auth.middleware';
export declare class JobsController {
    static create(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static list(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static getById(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static cancel(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static myPosts(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static updateStatus(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static apply(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static getApplicants(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
    static assignWorker(req: AuthRequest, res: Response, next: NextFunction): Promise<void>;
}
//# sourceMappingURL=jobs.controller.d.ts.map