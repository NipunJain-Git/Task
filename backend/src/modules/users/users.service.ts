import prisma from '../../config/database';
import { ApiError } from '../../utils/api-error';

export class UsersService {
  static async getMe(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: { workerProfile: true, householdProfile: true },
    });
    if (!user) throw new ApiError(404, 'USER_NOT_FOUND', 'User not found.');

    const result: Record<string, unknown> = { ...user };
    if (user.workerProfile) {
      result.workerProfile = {
        ...user.workerProfile,
        skills: JSON.parse(user.workerProfile.skills || '[]'),
      };
    }
    return result;
  }

  static async updateProfile(userId: string, data: { name?: string; language?: string; latitude?: number; longitude?: number }) {
    return prisma.user.update({ where: { id: userId }, data });
  }

  static async updateWorkerProfile(userId: string, data: { skills?: string[]; expectedWage?: number; wageType?: 'DAILY' | 'HOURLY'; workRadius?: number }) {
    const updateData: Record<string, unknown> = {};
    if (data.skills) updateData.skills = JSON.stringify(data.skills);
    if (data.expectedWage !== undefined) updateData.expectedWage = data.expectedWage;
    if (data.wageType) updateData.wageType = data.wageType;
    if (data.workRadius !== undefined) updateData.workRadius = data.workRadius;

    return prisma.workerProfile.update({
      where: { userId },
      data: updateData,
    });
  }

  static async updateHouseholdProfile(userId: string, data: { address?: string }) {
    return prisma.householdProfile.update({
      where: { userId },
      data,
    });
  }

  static async toggleAvailability(userId: string, isAvailable: boolean) {
    return prisma.workerProfile.update({
      where: { userId },
      data: { isAvailable },
    });
  }

  static async getUserById(id: string) {
    const user = await prisma.user.findUnique({
      where: { id },
      include: { workerProfile: true, householdProfile: true },
    });
    if (!user) throw new ApiError(404, 'USER_NOT_FOUND', 'User not found.');

    // Mask phone for privacy
    const result: Record<string, unknown> = {
      ...user,
      phone: user.phone.replace(/(\d{2})\d+(\d{2})/, '$1****$2'),
    };
    if (user.workerProfile) {
      result.workerProfile = {
        ...user.workerProfile,
        skills: JSON.parse(user.workerProfile.skills || '[]'),
      };
    }
    return result;
  }

  static async getRatingSummary(userId: string) {
    const ratings = await prisma.rating.findMany({
      where: { ratedUserId: userId },
      orderBy: { createdAt: 'desc' },
      take: 10,
      include: { rater: { select: { name: true, photoUrl: true } } },
    });

    const total = ratings.length;
    const allRatings = await prisma.rating.findMany({ where: { ratedUserId: userId } });
    const thumbsUp = allRatings.filter(r => r.value === 'THUMBS_UP').length;
    const thumbsDown = allRatings.filter(r => r.value === 'THUMBS_DOWN').length;
    const totalAll = allRatings.length;
    const positivePercent = totalAll > 0 ? Math.round((thumbsUp / totalAll) * 100) : 0;

    return {
      thumbsUp,
      thumbsDown,
      total: totalAll,
      positivePercent,
      recentRatings: ratings,
    };
  }
}
