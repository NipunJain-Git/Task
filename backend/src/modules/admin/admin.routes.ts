import { Router } from 'express';
import { getPlatformStats, getPendingKycList, updateKycStatus } from './admin.controller';

const router = Router();

router.get('/stats', getPlatformStats);
router.get('/kyc/pending', getPendingKycList);
router.put('/kyc/:userId/status', updateKycStatus);

export default router;
