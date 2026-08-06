import { Response, NextFunction } from 'express';
import { RatingsService } from './ratings.service';
import { sendSuccess } from '../../utils/api-response';
import { AuthRequest } from '../../middleware/auth.middleware';

export class RatingsController {
  static async submit(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await RatingsService.submitRating(req.params.id, req.userId!, req.body);
      sendSuccess(res, result, undefined, 201);
    } catch (err) { next(err); }
  }
}
