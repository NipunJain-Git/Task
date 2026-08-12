"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_middleware_1 = require("../../middleware/auth.middleware");
const chat_controller_1 = require("./chat.controller");
const router = (0, express_1.Router)();
router.get('/inbox', auth_middleware_1.authMiddleware, chat_controller_1.ChatController.getInbox);
router.get('/:jobId', auth_middleware_1.authMiddleware, chat_controller_1.ChatController.getMessages);
router.post('/:jobId', auth_middleware_1.authMiddleware, chat_controller_1.ChatController.sendMessage);
exports.default = router;
//# sourceMappingURL=chat.routes.js.map