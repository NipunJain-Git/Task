import { Router } from 'express';
import { UsersController } from './users.controller';
import { validate } from '../../middleware/validate.middleware';
import { updateProfileSchema, updateWorkerProfileSchema, updateHouseholdProfileSchema, toggleAvailabilitySchema } from './users.validators';
import { authMiddleware, roleMiddleware } from '../../middleware/auth.middleware';

const router = Router();

router.get('/me', authMiddleware, UsersController.getMe);
router.put('/me', authMiddleware, validate(updateProfileSchema), UsersController.updateProfile);
router.put('/me/worker-profile', authMiddleware, roleMiddleware('WORKER'), validate(updateWorkerProfileSchema), UsersController.updateWorkerProfile);
router.put('/me/household-profile', authMiddleware, roleMiddleware('HOUSEHOLD'), validate(updateHouseholdProfileSchema), UsersController.updateHouseholdProfile);
router.patch('/me/availability', authMiddleware, roleMiddleware('WORKER'), validate(toggleAvailabilitySchema), UsersController.toggleAvailability);
router.patch('/me/fcm-token', authMiddleware, UsersController.updateFcmToken);
router.patch('/me/location', authMiddleware, UsersController.updateLocation);
router.get('/:id', authMiddleware, UsersController.getUserById);
router.get('/:id/ratings', authMiddleware, UsersController.getRatingSummary);
router.post('/kyc', authMiddleware, UsersController.submitKyc);

export default router;
