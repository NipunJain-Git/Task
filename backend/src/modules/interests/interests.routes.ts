import { Router } from 'express';
import { InterestsController } from './interests.controller';
import { validate } from '../../middleware/validate.middleware';
import { acceptRejectSchema } from './interests.validators';
import { authMiddleware, roleMiddleware } from '../../middleware/auth.middleware';

const router = Router();

router.post('/:id/interest', authMiddleware, roleMiddleware('WORKER'), InterestsController.express);
router.get('/:id/interests', authMiddleware, roleMiddleware('HOUSEHOLD'), InterestsController.list);
router.patch('/:id/interests/:interestId', authMiddleware, roleMiddleware('HOUSEHOLD'), validate(acceptRejectSchema), InterestsController.acceptOrReject);
router.get('/my-interests', authMiddleware, roleMiddleware('WORKER'), InterestsController.myInterests);

export default router;
