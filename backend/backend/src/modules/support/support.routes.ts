import { Router } from 'express';
import { SupportController } from './support.controller';
import { authMiddleware } from '../../middleware/auth.middleware';

const router = Router();

router.use(authMiddleware);
router.post('/chat', SupportController.chat);

export default router;
