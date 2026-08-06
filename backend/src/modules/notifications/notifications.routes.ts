import { Router } from 'express';
import { NotificationsController } from './notifications.controller';
import { authMiddleware } from '../../middleware/auth.middleware';

const router = Router();

router.get('/', authMiddleware, NotificationsController.list);
router.get('/unread-count', authMiddleware, NotificationsController.unreadCount);
router.patch('/:id/read', authMiddleware, NotificationsController.markRead);

export default router;
