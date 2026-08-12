"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_controller_1 = require("./auth.controller");
const validate_middleware_1 = require("../../middleware/validate.middleware");
const auth_validators_1 = require("./auth.validators");
const auth_middleware_1 = require("../../middleware/auth.middleware");
const router = (0, express_1.Router)();
router.post('/send-otp', (0, validate_middleware_1.validate)(auth_validators_1.sendOtpSchema), auth_controller_1.AuthController.sendOtp);
router.post('/verify-otp', (0, validate_middleware_1.validate)(auth_validators_1.verifyOtpSchema), auth_controller_1.AuthController.verifyOtp);
router.post('/verify-firebase', auth_controller_1.AuthController.verifyFirebase);
router.post('/refresh', auth_controller_1.AuthController.refresh);
router.post('/select-role', auth_middleware_1.authMiddleware, (0, validate_middleware_1.validate)(auth_validators_1.selectRoleSchema), auth_controller_1.AuthController.selectRole);
exports.default = router;
//# sourceMappingURL=auth.routes.js.map