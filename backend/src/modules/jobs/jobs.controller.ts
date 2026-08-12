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
      const job = await JobsService.updateJobStatus(req.params.id, req.userId!, req.body.status);
      sendSuccess(res, job);
    } catch (err) { next(err); }
  }

  static async apply(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const interest = await JobsService.applyForJob(req.params.id, req.userId!);
      sendSuccess(res, interest);
    } catch (err) { next(err); }
  }

  static async getApplicants(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const applicants = await JobsService.getApplicants(req.params.id, req.userId!);
      sendSuccess(res, applicants);
    } catch (err) { next(err); }
  }

  static async assignWorker(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const { workerId } = req.body;
      const job = await JobsService.assignWorker(req.params.id, req.userId!, workerId);
      sendSuccess(res, job);
    } catch (err) { next(err); }
  }
}
