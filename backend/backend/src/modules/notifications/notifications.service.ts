import prisma from '../../config/database';

export class NotificationsService {
  static async list(userId: string) {
    return prisma.notification.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: 50,
    });
  }

  static async markRead(notificationId: string, userId: string) {
    return prisma.notification.updateMany({
      where: { id: notificationId, userId },
      data: { isRead: true },
    });
  }

  static async getUnreadCount(userId: string) {
    return prisma.notification.count({
      where: { userId, isRead: false },
    });
  }
}
