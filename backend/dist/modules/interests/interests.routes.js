"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const interests_controller_1 = require("./interests.controller");
const validate_middleware_1 = require("../../middleware/validate.middleware");
const interests_validators_1 = require("./interests.validators");
const auth_middleware_1 = require("../../middleware/auth.middleware");
const router = (0, express_1.Router)();
router.post('/:id/interest', auth_middleware_1.authMiddleware, (0, auth_middleware_1.roleMiddleware)('WORKER'), interests_controller_1.InterestsController.express);
router.get('/:id/interests', auth_middleware_1.authMiddleware, (0, auth_middleware_1.roleMiddleware)('HOUSEHOLD'), interests_controller_1.InterestsController.list);
router.patch('/:id/interests/:interestId', auth_middleware_1.authMiddleware, (0, auth_middleware_1.roleMiddleware)('HOUSEHOLD'), (0, validate_middleware_1.validate)(interests_validators_1.acceptRejectSchema), interests_controller_1.InterestsController.acceptOrReject);
router.get('/my-interests', auth_middleware_1.authMiddleware, (0, auth_middleware_1.roleMiddleware)('WORKER'), interests_controller_1.InterestsController.myInterests);
exports.default = router;
//# sourceMappingURL=interests.routes.js.map