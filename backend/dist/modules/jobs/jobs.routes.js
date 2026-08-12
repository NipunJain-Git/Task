"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const jobs_controller_1 = require("./jobs.controller");
const validate_middleware_1 = require("../../middleware/validate.middleware");
const jobs_validators_1 = require("./jobs.validators");
const auth_middleware_1 = require("../../middleware/auth.middleware");
const router = (0, express_1.Router)();
router.post('/', auth_middleware_1.authMiddleware, (0, auth_middleware_1.roleMiddleware)('HOUSEHOLD', 'ADMIN'), (0, validate_middleware_1.validate)(jobs_validators_1.createJobSchema), jobs_controller_1.JobsController.create);
router.get('/', auth_middleware_1.authMiddleware, (0, validate_middleware_1.validate)(jobs_validators_1.jobFiltersSchema, 'query'), jobs_controller_1.JobsController.list);
router.get('/my-posts', auth_middleware_1.authMiddleware, (0, auth_middleware_1.roleMiddleware)('HOUSEHOLD', 'ADMIN'), jobs_controller_1.JobsController.myPosts);
router.get('/:id', auth_middleware_1.authMiddleware, jobs_controller_1.JobsController.getById);
router.delete('/:id', auth_middleware_1.authMiddleware, (0, auth_middleware_1.roleMiddleware)('HOUSEHOLD', 'ADMIN'), jobs_controller_1.JobsController.cancel);
router.patch('/:id/status', auth_middleware_1.authMiddleware, (0, validate_middleware_1.validate)(jobs_validators_1.updateJobStatusSchema), jobs_controller_1.JobsController.updateStatus);
router.post('/:id/apply', auth_middleware_1.authMiddleware, (0, auth_middleware_1.roleMiddleware)('WORKER'), jobs_controller_1.JobsController.apply);
router.get('/:id/applicants', auth_middleware_1.authMiddleware, (0, auth_middleware_1.roleMiddleware)('HOUSEHOLD', 'ADMIN'), jobs_controller_1.JobsController.getApplicants);
router.post('/:id/assign', auth_middleware_1.authMiddleware, (0, auth_middleware_1.roleMiddleware)('HOUSEHOLD', 'ADMIN'), jobs_controller_1.JobsController.assignWorker);
exports.default = router;
//# sourceMappingURL=jobs.routes.js.map