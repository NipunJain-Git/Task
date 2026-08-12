"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.NotificationsService = void 0;
const database_1 = __importDefault(require("../../config/database"));
class NotificationsService {
    static async list(userId) {
        return database_1.default.notification.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
            take: 50,
        });
    }
    static async markRead(notificationId, userId) {
        return database_1.default.notification.updateMany({
            where: { id: notificationId, userId },
            data: { isRead: true },
        });
    }
    static async getUnreadCount(userId) {
        return database_1.default.notification.count({
            where: { userId, isRead: false },
        });
    }
}
exports.NotificationsService = NotificationsService;
//# sourceMappingURL=notifications.service.js.map