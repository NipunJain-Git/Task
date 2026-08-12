"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const wallet_controller_1 = require("./wallet.controller");
const validate_middleware_1 = require("../../middleware/validate.middleware");
const wallet_validators_1 = require("./wallet.validators");
const auth_middleware_1 = require("../../middleware/auth.middleware");
const router = (0, express_1.Router)();
router.use(auth_middleware_1.authMiddleware);
router.get('/', wallet_controller_1.WalletController.getWallet);
router.post('/setup-pin', (0, validate_middleware_1.validate)(wallet_validators_1.setupPinSchema), wallet_controller_1.WalletController.setupPin);
router.post('/add-money', (0, validate_middleware_1.validate)(wallet_validators_1.addMoneySchema), wallet_controller_1.WalletController.addMoney);
router.post('/transfer-family', (0, validate_middleware_1.validate)(wallet_validators_1.transferToFamilySchema), wallet_controller_1.WalletController.transferToFamily);
router.post('/job-payout', (0, validate_middleware_1.validate)(wallet_validators_1.jobPayoutSchema), wallet_controller_1.WalletController.jobPayout);
exports.default = router;
//# sourceMappingURL=wallet.routes.js.map