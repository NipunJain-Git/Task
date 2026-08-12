"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendSuccess = sendSuccess;
exports.sendError = sendError;
function sendSuccess(res, data, meta, statusCode = 200) {
    const response = { success: true, data };
    if (meta) {
        response.meta = meta;
    }
    res.status(statusCode).json(response);
}
function sendError(res, statusCode, code, message) {
    res.status(statusCode).json({
        success: false,
        error: { code, message, statusCode },
    });
}
//# sourceMappingURL=api-response.js.map