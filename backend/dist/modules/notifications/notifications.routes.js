"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const notifications_controller_1 = require("./notifications.controller");
const auth_middleware_1 = require("../../middleware/auth.middleware");
const router = (0, express_1.Router)();
router.get('/', auth_middleware_1.authMiddleware, notifications_controller_1.NotificationsController.list);
router.get('/unread-count', auth_middleware_1.authMiddleware, notifications_controller_1.NotificationsController.unreadCount);
router.patch('/:id/read', auth_middleware_1.authMiddleware, notifications_controller_1.NotificationsController.markRead);
exports.default = router;
//# sourceMappingURL=notifications.routes.js.map