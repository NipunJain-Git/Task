"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.NotificationsController = void 0;
const notifications_service_1 = require("./notifications.service");
const api_response_1 = require("../../utils/api-response");
class NotificationsController {
    static async list(req, res, next) {
        try {
            const result = await notifications_service_1.NotificationsService.list(req.userId);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async markRead(req, res, next) {
        try {
            await notifications_service_1.NotificationsService.markRead(req.params.id, req.userId);
            (0, api_response_1.sendSuccess)(res, { success: true });
        }
        catch (err) {
            next(err);
        }
    }
    static async unreadCount(req, res, next) {
        try {
            const count = await notifications_service_1.NotificationsService.getUnreadCount(req.userId);
            (0, api_response_1.sendSuccess)(res, { count });
        }
        catch (err) {
            next(err);
        }
    }
}
exports.NotificationsController = NotificationsController;
//# sourceMappingURL=notifications.controller.js.map