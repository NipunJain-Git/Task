"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authMiddleware = authMiddleware;
exports.roleMiddleware = roleMiddleware;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const env_1 = require("../config/env");
const api_error_1 = require("../utils/api-error");
function authMiddleware(req, _res, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        throw new api_error_1.ApiError(401, 'UNAUTHORIZED', 'Authentication token is required.');
    }
    const token = authHeader.split(' ')[1];
    try {
        const decoded = jsonwebtoken_1.default.verify(token, env_1.env.JWT_SECRET);
        req.userId = decoded.userId;
        req.userRole = decoded.role;
        next();
    }
    catch {
        throw new api_error_1.ApiError(401, 'TOKEN_EXPIRED', 'Authentication token is invalid or expired.');
    }
}
function roleMiddleware(...roles) {
    const upperRoles = roles.map(r => r.toUpperCase());
    return (req, _res, next) => {
        const userRole = req.userRole?.toUpperCase();
        if (!userRole || !upperRoles.includes(userRole)) {
            throw new api_error_1.ApiError(403, 'FORBIDDEN', 'You do not have permission to perform this action.');
        }
        next();
    };
}
//# sourceMappingURL=auth.middleware.js.map