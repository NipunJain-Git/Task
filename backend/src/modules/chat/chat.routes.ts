import { Router } from 'express';
import { authMiddleware } from '../../middleware/auth.middleware';
import { ChatController } from './chat.controller';

const router = Router();
router.get('/inbox', authMiddleware, ChatController.getInbox);
router.get('/:jobId', authMiddleware, ChatController.getMessages);
router.post('/:jobId', authMiddleware, ChatController.sendMessage);
export default router;
