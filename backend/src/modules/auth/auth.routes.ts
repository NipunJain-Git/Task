import { Router } from 'express';
import { AuthController } from './auth.controller';
import { validate } from '../../middleware/validate.middleware';
import { sendOtpSchema, verifyOtpSchema, selectRoleSchema } from './auth.validators';
import { authMiddleware } from '../../middleware/auth.middleware';

const router = Router();

router.post('/send-otp', validate(sendOtpSchema), AuthController.sendOtp);
router.post('/verify-otp', validate(verifyOtpSchema), AuthController.verifyOtp);
router.post('/verify-firebase', AuthController.verifyFirebase);
router.post('/refresh', AuthController.refresh);
router.post('/select-role', authMiddleware, validate(selectRoleSchema), AuthController.selectRole);

export default router;
