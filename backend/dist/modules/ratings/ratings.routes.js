"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const ratings_controller_1 = require("./ratings.controller");
const validate_middleware_1 = require("../../middleware/validate.middleware");
const ratings_validators_1 = require("./ratings.validators");
const auth_middleware_1 = require("../../middleware/auth.middleware");
const router = (0, express_1.Router)();
router.post('/:id/rate', auth_middleware_1.authMiddleware, (0, validate_middleware_1.validate)(ratings_validators_1.submitRatingSchema), ratings_controller_1.RatingsController.submit);
exports.default = router;
//# sourceMappingURL=ratings.routes.js.map