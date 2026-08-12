"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const admin_controller_1 = require("./admin.controller");
const router = (0, express_1.Router)();
router.get('/stats', admin_controller_1.getPlatformStats);
router.get('/kyc/pending', admin_controller_1.getPendingKycList);
router.put('/kyc/:userId/status', admin_controller_1.updateKycStatus);
exports.default = router;
//# sourceMappingURL=admin.routes.js.map