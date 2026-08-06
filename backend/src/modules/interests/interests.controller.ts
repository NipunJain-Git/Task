import { Response, NextFunction } from 'express';
import { InterestsService } from './interests.service';
import { sendSuccess } from '../../utils/api-response';
import { AuthRequest } from '../../middleware/auth.middleware';

export class InterestsController {
  static async express(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await InterestsService.expressInterest(req.params.id, req.userId!);
      sendSuccess(res, result, undefined, 201);
    } catch (err) { next(err); }
  }

  static async list(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await InterestsService.listInterestedWorkers(req.params.id, req.userId!);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async acceptOrReject(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await InterestsService.acceptOrReject(req.params.id, req.params.interestId, req.userId!, req.body.action);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async myInterests(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await InterestsService.getMyInterests(req.userId!);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }
}
