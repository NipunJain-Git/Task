import { Router } from 'express';
import { RatingsController } from './ratings.controller';
import { validate } from '../../middleware/validate.middleware';
import { submitRatingSchema } from './ratings.validators';
import { authMiddleware } from '../../middleware/auth.middleware';

const router = Router();

router.post('/:id/rate', authMiddleware, validate(submitRatingSchema), RatingsController.submit);

export default router;
