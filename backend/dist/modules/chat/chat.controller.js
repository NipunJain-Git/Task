"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ChatController = void 0;
const api_response_1 = require("../../utils/api-response");
const database_1 = __importDefault(require("../../config/database"));
const fcm_1 = require("../../utils/fcm");
class ChatController {
    static async getMessages(req, res, next) {
        try {
            const messages = await database_1.default.message.findMany({
                where: {
                    jobId: req.params.jobId,
                    OR: [
                        { senderId: req.userId },
                        { receiverId: req.userId },
                    ],
                },
                orderBy: { createdAt: 'asc' },
            });
            (0, api_response_1.sendSuccess)(res, messages);
        }
        catch (err) {
            next(err);
        }
    }
    static async sendMessage(req, res, next) {
        try {
            const { receiverId, text } = req.body;
            const message = await database_1.default.message.create({
                data: {
                    jobId: req.params.jobId,
                    senderId: req.userId,
                    receiverId,
                    text,
                },
            });
            // Send push notification to receiver
            const receiver = await database_1.default.user.findUnique({ where: { id: receiverId } });
            if (receiver?.fcmToken) {
                await (0, fcm_1.sendPushNotification)({
                    fcmToken: receiver.fcmToken,
                    title: 'New Message',
                    body: text.substring(0, 100),
                    data: { type: 'CHAT', jobId: req.params.jobId },
                });
            }
            (0, api_response_1.sendSuccess)(res, message);
        }
        catch (err) {
            next(err);
        }
    }
    static async getInbox(req, res, next) {
        try {
            const messages = await database_1.default.message.findMany({
                where: {
                    OR: [
                        { senderId: req.userId },
                        { receiverId: req.userId },
                    ],
                },
                orderBy: { createdAt: 'desc' },
            });
            // Group by distinct conversations
            const conversations = new Map();
            for (const msg of messages) {
                const otherUserId = msg.senderId === req.userId ? msg.receiverId : msg.senderId;
                const key = `${msg.jobId}-${otherUserId}`;
                if (!conversations.has(key)) {
                    conversations.set(key, {
                        jobId: msg.jobId,
                        otherUserId,
                        lastMessage: msg.text,
                        isRead: msg.isRead,
                        createdAt: msg.createdAt,
                        senderId: msg.senderId,
                    });
                }
            }
            // Fetch user and job details for the conversations
            const inbox = await Promise.all(Array.from(conversations.values()).map(async (conv) => {
                const otherUser = await database_1.default.user.findUnique({ where: { id: conv.otherUserId }, select: { name: true, photoUrl: true, role: true } });
                const job = await database_1.default.job.findUnique({ where: { id: conv.jobId }, select: { title: true, status: true } });
                return {
                    ...conv,
                    otherUserName: otherUser?.name || (otherUser?.role === 'WORKER' ? 'Worker' : 'Household'),
                    otherUserPhoto: otherUser?.photoUrl,
                    jobTitle: job?.title || 'Unknown Job',
                    jobStatus: job?.status,
                };
            }));
            (0, api_response_1.sendSuccess)(res, inbox);
        }
        catch (err) {
            next(err);
        }
    }
}
exports.ChatController = ChatController;
//# sourceMappingURL=chat.controller.js.map