import { Response, NextFunction } from 'express';
import { JobsService } from './jobs.service';
import { sendSuccess } from '../../utils/api-response';
import { AuthRequest } from '../../middleware/auth.middleware';

export class JobsController {
  static async create(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await JobsService.createJob(req.userId!, req.body);
      sendSuccess(res, result, undefined, 201);
    } catch (err) { next(err); }
  }

  static async list(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await JobsService.listJobs(req.query as any);
      sendSuccess(res, result.jobs, result.meta);
    } catch (err) { next(err); }
  }

  static async getById(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await JobsService.getJobById(req.params.id);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async cancel(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await JobsService.cancelJob(req.params.id, req.userId!);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async myPosts(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await JobsService.getMyPosts(req.userId!);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }

  static async updateStatus(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await JobsService.updateJobStatus(req.params.id, req.userId!, req.body.status);
      sendSuccess(res, result);
    } catch (err) { next(err); }
  }
}
