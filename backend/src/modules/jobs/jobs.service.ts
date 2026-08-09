import prisma from '../../config/database';
import { ApiError } from '../../utils/api-error';

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
    return prisma.job.create({
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
      }).map(job => ({
        ...job,
        distance: Math.round(getDistanceKm(filters.latitude!, filters.longitude!, job.latitude, job.longitude) * 10) / 10,
      }));
    }

    return { jobs: filtered, meta: { page, limit, total } };
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
}
