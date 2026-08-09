import { Router } from 'express';
import { WalletController } from './wallet.controller';
import { validate } from '../../middleware/validate.middleware';
import { setupPinSchema, addMoneySchema, transferToFamilySchema, jobPayoutSchema } from './wallet.validators';
import { authMiddleware } from '../../middleware/auth.middleware';

const router = Router();

router.use(authMiddleware);

router.get('/', WalletController.getWallet);
router.post('/setup-pin', validate(setupPinSchema), WalletController.setupPin);
router.post('/add-money', validate(addMoneySchema), WalletController.addMoney);
router.post('/transfer-family', validate(transferToFamilySchema), WalletController.transferToFamily);
router.post('/job-payout', validate(jobPayoutSchema), WalletController.jobPayout);

export default router;
