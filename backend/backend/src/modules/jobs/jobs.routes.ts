import { Router } from 'express';
import { JobsController } from './jobs.controller';
import { validate } from '../../middleware/validate.middleware';
import { createJobSchema, jobFiltersSchema, updateJobStatusSchema } from './jobs.validators';
import { authMiddleware, roleMiddleware } from '../../middleware/auth.middleware';

const router = Router();

router.post('/', authMiddleware, roleMiddleware('HOUSEHOLD'), validate(createJobSchema), JobsController.create);
router.get('/', authMiddleware, validate(jobFiltersSchema, 'query'), JobsController.list);
router.get('/my-posts', authMiddleware, roleMiddleware('HOUSEHOLD'), JobsController.myPosts);
router.get('/:id', authMiddleware, JobsController.getById);
router.delete('/:id', authMiddleware, roleMiddleware('HOUSEHOLD'), JobsController.cancel);
router.patch('/:id/status', authMiddleware, validate(updateJobStatusSchema), JobsController.updateStatus);

export default router;
