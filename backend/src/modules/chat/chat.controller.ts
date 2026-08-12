import { Response, NextFunction } from 'express';
import { AuthRequest } from '../../middleware/auth.middleware';
import { sendSuccess } from '../../utils/api-response';
import prisma from '../../config/database';
import { sendPushNotification } from '../../utils/fcm';

export class ChatController {
  static async getMessages(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const messages = await (prisma as any).message.findMany({
        where: {
          jobId: req.params.jobId,
          OR: [
            { senderId: req.userId },
            { receiverId: req.userId },
          ],
        },
        orderBy: { createdAt: 'asc' },
      });
      sendSuccess(res, messages);
    } catch (err) { next(err); }
  }

  static async sendMessage(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const { receiverId, text } = req.body;
      const message = await (prisma as any).message.create({
        data: {
          jobId: req.params.jobId,
          senderId: req.userId!,
          receiverId,
          text,
        },
      });
      // Send push notification to receiver
      const receiver = await prisma.user.findUnique({ where: { id: receiverId } });
      if (receiver?.fcmToken) {
        await sendPushNotification({
          fcmToken: receiver.fcmToken,
          title: 'New Message',
          body: text.substring(0, 100),
          data: { type: 'CHAT', jobId: req.params.jobId },
        });
      }
      sendSuccess(res, message);
    } catch (err) { next(err); }
  }

  static async getInbox(req: AuthRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const messages = await (prisma as any).message.findMany({
        where: {
          OR: [
            { senderId: req.userId },
            { receiverId: req.userId },
          ],
        },
        orderBy: { createdAt: 'desc' },
      });

      // Group by distinct conversations
      const conversations = new Map<string, any>();
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
        const otherUser = await prisma.user.findUnique({ where: { id: conv.otherUserId }, select: { name: true, photoUrl: true, role: true } });
        const job = await prisma.job.findUnique({ where: { id: conv.jobId }, select: { title: true, status: true } });
        return {
          ...conv,
          otherUserName: otherUser?.name || (otherUser?.role === 'WORKER' ? 'Worker' : 'Household'),
          otherUserPhoto: otherUser?.photoUrl,
          jobTitle: job?.title || 'Unknown Job',
          jobStatus: job?.status,
        };
      }));

      sendSuccess(res, inbox);
    } catch (err) { next(err); }
  }
}
