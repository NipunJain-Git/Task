import prisma from '../../config/database';
import { ApiError } from '../../utils/api-error';
import { sendPushNotification } from '../../utils/fcm';

function haversineKm(lat1: number, lng1: number, lat2: number, lng2: number): number {
  const R = 6371;
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLng = ((lng2 - lng1) * Math.PI) / 180;
  const a = Math.sin(dLat / 2) ** 2 + Math.cos((lat1 * Math.PI) / 180) * Math.cos((lat2 * Math.PI) / 180) * Math.sin(dLng / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

function getDistanceKm(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371;
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) * Math.cos((lat2 * Math.PI) / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

export class JobsService {
  static async createJob(householdId: string, data: {
    title: string; description: string; category: string; jobDate: string;
    jobTime?: string; latitude: number; longitude: number; address?: string;
    budgetAmount: number; budgetType?: 'FIXED' | 'NEGOTIABLE';
  }) {
    const job = await prisma.job.create({
      data: {
        householdId,
        title: data.title,
        description: data.description,
        category: data.category,
        jobDate: new Date(data.jobDate),
        jobTime: data.jobTime,
        latitude: data.latitude,
        longitude: data.longitude,
        address: data.address,
        budgetAmount: data.budgetAmount,
        budgetType: data.budgetType || 'FIXED',
      },
      include: { household: { select: { id: true, name: true, photoUrl: true } } },
    });

    try {
      const workers = await prisma.user.findMany({
        where: { role: 'WORKER', fcmToken: { not: null } }
      });
      for (const worker of workers) {
        if (worker.latitude && worker.longitude && worker.fcmToken) {
          const dist = haversineKm(data.latitude, data.longitude, worker.latitude, worker.longitude);
          if (dist <= 10) {
            await sendPushNotification({
              fcmToken: worker.fcmToken,
              title: 'New Job Posted Nearby!',
              body: `${data.title} in ${data.category}`,
              data: { type: 'NEW_JOB', jobId: job.id }
            });
          }
        }
      }
    } catch (err) {
      console.error('Failed to send push notifications', err);
    }

    return job;
  }

  static async listJobs(filters: {
    latitude?: number; longitude?: number; radius?: number;
    category?: string; status?: string; page?: number; limit?: number;
  }) {
    const page = filters.page || 1;
    const limit = filters.limit || 20;
    const skip = (page - 1) * limit;

    const where: Record<string, unknown> = {
      deletedAt: null,
      status: filters.status || 'OPEN',
    };
    if (filters.category) where.category = filters.category;

    const [jobs, total] = await Promise.all([
      prisma.job.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: {
          household: { select: { id: true, name: true, photoUrl: true } },
          _count: { select: { interests: true } },
        },
      }),
      prisma.job.count({ where }),
    ]);

    // Apply distance filter if lat/lng provided
    let filtered = jobs;
    if (filters.latitude && filters.longitude) {
      const radius = filters.radius || 10;
      filtered = jobs.filter(job => {
        const dist = getDistanceKm(filters.latitude!, filters.longitude!, job.latitude, job.longitude);
        return dist <= radius;
      });
    }

    const mappedJobs = filtered.map(job => ({
      id: job.id,
      title: job.title,
      description: job.description,
      category: job.category,
      jobDate: job.jobDate,
      jobTime: job.jobTime,
      address: job.address,
      latitude: job.latitude,
      longitude: job.longitude,
      budgetAmount: job.budgetAmount,
      budgetType: job.budgetType,
      status: job.status,
      createdAt: job.createdAt,
      household: {
        id: job.household?.id,
        name: job.household?.name,
        photoUrl: job.household?.photoUrl
      },
      distance: (filters.latitude && filters.longitude) 
        ? Math.round(getDistanceKm(filters.latitude, filters.longitude, job.latitude, job.longitude) * 10) / 10 
        : 0
    }));

    return { jobs: mappedJobs, meta: { page, limit, total } };
  }

  static async getJobById(jobId: string) {
    const job = await prisma.job.findUnique({
      where: { id: jobId },
      include: {
        household: { select: { id: true, name: true, photoUrl: true, householdProfile: true } },
        assignedWorker: { select: { id: true, name: true, photoUrl: true, workerProfile: true } },
        _count: { select: { interests: true, ratings: true } },
      },
    });
    if (!job || job.deletedAt) throw new ApiError(404, 'JOB_NOT_FOUND', 'The requested job does not exist.');
    return job;
  }

  static async cancelJob(jobId: string, userId: string) {
    const job = await prisma.job.findUnique({ where: { id: jobId } });
    if (!job) throw new ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');
    if (job.householdId !== userId) throw new ApiError(403, 'FORBIDDEN', 'You can only cancel your own jobs.');
    if (job.status !== 'OPEN' && job.status !== 'ASSIGNED') {
      throw new ApiError(400, 'INVALID_STATUS', 'Only OPEN or ASSIGNED jobs can be cancelled.');
    }
    return prisma.job.update({ where: { id: jobId }, data: { status: 'CANCELLED' } });
  }

  static async getMyPosts(userId: string) {
    return prisma.job.findMany({
      where: { householdId: userId, deletedAt: null },
      orderBy: { createdAt: 'desc' },
      include: {
        _count: { select: { interests: true } },
        assignedWorker: { select: { id: true, name: true, photoUrl: true } },
      },
    });
  }

  static async updateJobStatus(jobId: string, userId: string, status: string) {
    const job = await prisma.job.findUnique({ where: { id: jobId } });
    if (!job) throw new ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');

    // Validate status transitions
    const validTransitions: Record<string, string[]> = {
      ASSIGNED: ['IN_PROGRESS'],
      IN_PROGRESS: ['COMPLETED'],
      OPEN: ['CANCELLED'],
    };

    const allowed = validTransitions[job.status] || [];
    if (!allowed.includes(status)) {
      throw new ApiError(400, 'INVALID_TRANSITION', `Cannot transition from ${job.status} to ${status}.`);
    }

    if (status === 'CANCELLED' && job.householdId !== userId) {
      throw new ApiError(403, 'FORBIDDEN', 'Only the household can cancel a job.');
    }

    return prisma.job.update({ where: { id: jobId }, data: { status: status as any } });
  }
  static async applyForJob(jobId: string, workerId: string) {
    const job = await prisma.job.findUnique({ where: { id: jobId } });
    if (!job) throw new ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');
    if (job.status !== 'OPEN') throw new ApiError(400, 'JOB_NOT_OPEN', 'Job is no longer open.');

    const interest = await prisma.jobInterest.upsert({
      where: { jobId_workerId: { jobId, workerId } },
      create: { jobId, workerId },
      update: {},
    });

    if (job.householdId) {
      const household = await prisma.user.findUnique({ where: { id: job.householdId } });
      if (household?.fcmToken) {
        await sendPushNotification({
          fcmToken: household.fcmToken,
          title: 'New Job Applicant!',
          body: `A worker has applied for your job: ${job.title}`,
          data: { type: 'NEW_APPLICANT', jobId }
        });
      }
    }

    return interest;
  }

  static async getApplicants(jobId: string, householdId: string) {
    const job = await prisma.job.findUnique({ where: { id: jobId } });
    if (!job) throw new ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');
    // Allow admin to see applicants too
    const user = await prisma.user.findUnique({ where: { id: householdId } });
    if (job.householdId !== householdId && user?.role !== 'ADMIN') {
      throw new ApiError(403, 'FORBIDDEN', 'You can only view applicants for your own jobs.');
    }

    return prisma.jobInterest.findMany({
      where: { jobId },
      include: {
        worker: {
          select: {
            id: true, name: true, photoUrl: true, phone: true,
            workerProfile: true
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  static async assignWorker(jobId: string, householdId: string, workerId: string) {
    const job = await prisma.job.findUnique({ where: { id: jobId } });
    if (!job) throw new ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');
    const user = await prisma.user.findUnique({ where: { id: householdId } });
    if (job.householdId !== householdId && user?.role !== 'ADMIN') {
      throw new ApiError(403, 'FORBIDDEN', 'You can only assign workers for your own jobs.');
    }
    if (job.status !== 'OPEN') throw new ApiError(400, 'JOB_NOT_OPEN', 'Job is no longer open.');

    const interest = await prisma.jobInterest.findUnique({ where: { jobId_workerId: { jobId, workerId } } });
    if (!interest) throw new ApiError(400, 'WORKER_NOT_APPLIED', 'Worker has not applied for this job.');

    const updatedJob = await prisma.job.update({
      where: { id: jobId },
      data: {
        status: 'ASSIGNED',
        assignedWorkerId: workerId,
      },
      include: { household: { select: { name: true } } }
    });

    // Accept the interest
    await prisma.jobInterest.update({
      where: { id: interest.id },
      data: { status: 'ACCEPTED' }
    });

    // Reject other interests
    await prisma.jobInterest.updateMany({
      where: { jobId, id: { not: interest.id } },
      data: { status: 'REJECTED' }
    });

    // Send push notification to the assigned worker
    const worker = await prisma.user.findUnique({ where: { id: workerId } });
    if (worker?.fcmToken) {
      await sendPushNotification({
        fcmToken: worker.fcmToken,
        title: 'You got the job!',
        body: `${updatedJob.household?.name || 'A household'} assigned you to: ${job.title}`,
        data: { type: 'JOB_ASSIGNED', jobId }
      });
    }

    // Initialize chat by sending a system welcome message
    await (prisma as any).message.create({
      data: {
        jobId,
        senderId: job.householdId,
        receiverId: workerId,
        text: 'Hello! I have assigned you to this job. When can you start?'
      }
    });

    return updatedJob;
  }
}
