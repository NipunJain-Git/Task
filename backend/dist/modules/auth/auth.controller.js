"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthController = void 0;
const auth_service_1 = require("./auth.service");
const api_response_1 = require("../../utils/api-response");
class AuthController {
    static async sendOtp(req, res, next) {
        try {
            const result = await auth_service_1.AuthService.sendOtp(req.body.phone);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async verifyOtp(req, res, next) {
        try {
            const result = await auth_service_1.AuthService.verifyOtp(req.body.phone, req.body.otp, req.body.sessionId);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async verifyFirebase(req, res, next) {
        try {
            const result = await auth_service_1.AuthService.verifyFirebase(req.body.idToken, req.body.role);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async refresh(req, res, next) {
        try {
            const result = await auth_service_1.AuthService.refreshToken(req.body.refreshToken);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async selectRole(req, res, next) {
        try {
            const { role, familyMemberContact, familyMemberRelation } = req.body;
            const result = await auth_service_1.AuthService.selectRole(req.userId, role, familyMemberContact, familyMemberRelation);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
}
exports.AuthController = AuthController;
//# sourceMappingURL=auth.controller.js.map