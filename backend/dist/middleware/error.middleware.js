"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.errorMiddleware = errorMiddleware;
const api_error_1 = require("../utils/api-error");
const logger_1 = __importDefault(require("../utils/logger"));
function errorMiddleware(err, _req, res, _next) {
    logger_1.default.error(err.message, { stack: err.stack, name: err.name });
    if (err instanceof api_error_1.ApiError) {
        res.status(err.statusCode).json({
            success: false,
            error: {
                code: err.code,
                message: err.message,
                statusCode: err.statusCode,
            },
        });
        return;
    }
    res.status(500).json({
        success: false,
        error: {
            code: 'INTERNAL_ERROR',
            message: 'An unexpected error occurred.',
            statusCode: 500,
        },
    });
}
//# sourceMappingURL=error.middleware.js.map