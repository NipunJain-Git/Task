import prisma from '../../config/database';
import { ApiError } from '../../utils/api-error';

export class InterestsService {
  static async expressInterest(jobId: string, workerId: string) {
    const job = await prisma.job.findUnique({ where: { id: jobId } });
    if (!job) throw new ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');
    if (job.status !== 'OPEN') throw new ApiError(400, 'JOB_NOT_OPEN', 'This job is no longer accepting interests.');

    // Check duplicate
    const existing = await prisma.jobInterest.findUnique({ where: { jobId_workerId: { jobId, workerId } } });
    if (existing) throw new ApiError(400, 'DUPLICATE_INTEREST', 'You have already expressed interest in this job.');

    // Check max 10 open interests
    const activeInterests = await prisma.jobInterest.count({
      where: { workerId, status: 'PENDING' },
    });
    if (activeInterests >= 10) {
      throw new ApiError(400, 'MAX_INTERESTS', 'You can only have 10 pending interests at a time.');
    }

    const interest = await prisma.jobInterest.create({
      data: { jobId, workerId },
      include: { worker: { select: { id: true, name: true, photoUrl: true } } },
    });

    // Create notification for household
    await prisma.notification.create({
      data: {
        userId: job.householdId,
        type: 'NEW_INTEREST',
        title: 'New Worker Interested',
        body: `A worker has expressed interest in your job "${job.title}".`,
        data: JSON.stringify({ jobId }),
      },
    });

    return interest;
  }

  static async listInterestedWorkers(jobId: string, userId: string) {
    const job = await prisma.job.findUnique({ where: { id: jobId } });
    if (!job) throw new ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');
    if (job.householdId !== userId) throw new ApiError(403, 'FORBIDDEN', 'Only the job poster can view interested workers.');

    const interests = await prisma.jobInterest.findMany({
      where: { jobId },
      include: {
        worker: {
          select: {
            id: true, name: true, photoUrl: true,
            workerProfile: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return interests.map(i => ({
      ...i,
      worker: {
        ...i.worker,
        workerProfile: i.worker.workerProfile ? {
          ...i.worker.workerProfile,
          skills: JSON.parse(i.worker.workerProfile.skills || '[]'),
        } : null,
      },
    }));
  }

  static async acceptOrReject(jobId: string, interestId: string, userId: string, action: 'ACCEPTED' | 'REJECTED') {
    const job = await prisma.job.findUnique({ where: { id: jobId } });
    if (!job) throw new ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');
    if (job.householdId !== userId) throw new ApiError(403, 'FORBIDDEN', 'Only the job poster can accept/reject workers.');

    const interest = await prisma.jobInterest.findUnique({ where: { id: interestId } });
    if (!interest) throw new ApiError(404, 'INTEREST_NOT_FOUND', 'Interest not found.');

    if (action === 'ACCEPTED') {
      // Accept this worker, reject all others, assign job
      await prisma.$transaction([
        prisma.jobInterest.update({ where: { id: interestId }, data: { status: 'ACCEPTED' } }),
        prisma.jobInterest.updateMany({
          where: { jobId, id: { not: interestId } },
          data: { status: 'REJECTED' },
        }),
        prisma.job.update({
          where: { id: jobId },
          data: { status: 'ASSIGNED', assignedWorkerId: interest.workerId },
        }),
      ]);

      // Notify accepted worker
      await prisma.notification.create({
        data: {
          userId: interest.workerId,
          type: 'SELECTED',
          title: 'You\'ve Been Selected!',
          body: `You have been selected for the job "${job.title}".`,
          data: JSON.stringify({ jobId }),
        },
      });
    } else {
      await prisma.jobInterest.update({ where: { id: interestId }, data: { status: 'REJECTED' } });
    }

    return { success: true };
  }

  static async getMyInterests(workerId: string) {
    return prisma.jobInterest.findMany({
      where: { workerId },
      include: {
        job: {
          select: {
            id: true, title: true, category: true, status: true,
            budgetAmount: true, budgetType: true, jobDate: true, address: true,
            household: { select: { id: true, name: true, photoUrl: true } },
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }
}
