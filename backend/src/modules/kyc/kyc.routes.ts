import { Router } from 'express';
import { uploadKyc, getKycStatus } from './kyc.controller';

const router = Router();

router.post('/upload', uploadKyc);
router.get('/:userId/status', getKycStatus);

export default router;
