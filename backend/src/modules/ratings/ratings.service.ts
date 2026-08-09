import prisma from '../../config/database';
import { ApiError } from '../../utils/api-error';

export class RatingsService {
  static async submitRating(jobId: string, raterId: string, data: { value: 'THUMBS_UP' | 'THUMBS_DOWN'; comment?: string }) {
    const job = await prisma.job.findUnique({ where: { id: jobId } });
    if (!job) throw new ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');
    if (job.status !== 'COMPLETED') throw new ApiError(400, 'JOB_NOT_COMPLETED', 'You can only rate after the job is completed.');

    // Determine who is being rated
    let ratedUserId: string;
    if (raterId === job.householdId) {
      ratedUserId = job.assignedWorkerId!;
    } else if (raterId === job.assignedWorkerId) {
      ratedUserId = job.householdId;
    } else {
      throw new ApiError(403, 'FORBIDDEN', 'You are not part of this job.');
    }

    // Check duplicate rating
    const existing = await prisma.rating.findUnique({ where: { jobId_raterId: { jobId, raterId } } });
    if (existing) throw new ApiError(400, 'ALREADY_RATED', 'You have already rated for this job.');

    const rating = await prisma.rating.create({
      data: { jobId, raterId, ratedUserId, value: data.value, comment: data.comment },
    });

    // Update profile counters
    const ratedUser = await prisma.user.findUnique({ where: { id: ratedUserId } });
    if (ratedUser?.role === 'WORKER') {
      const field = data.value === 'THUMBS_UP' ? 'thumbsUp' : 'thumbsDown';
      await prisma.workerProfile.update({
        where: { userId: ratedUserId },
        data: { [field]: { increment: 1 } },
      });
    } else if (ratedUser?.role === 'HOUSEHOLD') {
      const field = data.value === 'THUMBS_UP' ? 'thumbsUp' : 'thumbsDown';
      await prisma.householdProfile.update({
        where: { userId: ratedUserId },
        data: { [field]: { increment: 1 } },
      });
    }

    return rating;
  }
}
