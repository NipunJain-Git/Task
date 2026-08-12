"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const kyc_controller_1 = require("./kyc.controller");
const router = (0, express_1.Router)();
router.post('/upload', kyc_controller_1.uploadKyc);
router.get('/:userId/status', kyc_controller_1.getKycStatus);
exports.default = router;
//# sourceMappingURL=kyc.routes.js.map