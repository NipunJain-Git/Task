export declare class NotificationsService {
    static list(userId: string): Promise<{
        id: string;
        createdAt: Date;
        data: string | null;
        userId: string;
        body: string;
        type: string;
        title: string;
        isRead: boolean;
    }[]>;
    static markRead(notificationId: string, userId: string): Promise<import(".prisma/client").Prisma.BatchPayload>;
    static getUnreadCount(userId: string): Promise<number>;
}
//# sourceMappingURL=notifications.service.d.ts.map