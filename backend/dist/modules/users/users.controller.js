"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UsersController = void 0;
const users_service_1 = require("./users.service");
const api_response_1 = require("../../utils/api-response");
const database_1 = __importDefault(require("../../config/database"));
class UsersController {
    static async getMe(req, res, next) {
        try {
            const result = await users_service_1.UsersService.getMe(req.userId);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async updateProfile(req, res, next) {
        try {
            const result = await users_service_1.UsersService.updateProfile(req.userId, req.body);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async updateWorkerProfile(req, res, next) {
        try {
            const result = await users_service_1.UsersService.updateWorkerProfile(req.userId, req.body);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async updateHouseholdProfile(req, res, next) {
        try {
            const result = await users_service_1.UsersService.updateHouseholdProfile(req.userId, req.body);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async toggleAvailability(req, res, next) {
        try {
            const result = await users_service_1.UsersService.toggleAvailability(req.userId, req.body.isAvailable);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async getUserById(req, res, next) {
        try {
            const result = await users_service_1.UsersService.getUserById(req.params.id);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async getRatingSummary(req, res, next) {
        try {
            const result = await users_service_1.UsersService.getRatingSummary(req.params.id);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async updateFcmToken(req, res, next) {
        try {
            await database_1.default.user.update({
                where: { id: req.userId },
                data: { fcmToken: req.body.fcmToken },
            });
            (0, api_response_1.sendSuccess)(res, { message: 'FCM token updated' });
        }
        catch (err) {
            next(err);
        }
    }
    static async updateLocation(req, res, next) {
        try {
            await database_1.default.user.update({
                where: { id: req.userId },
                data: { latitude: req.body.latitude, longitude: req.body.longitude },
            });
            (0, api_response_1.sendSuccess)(res, { message: 'Location updated' });
        }
        catch (err) {
            next(err);
        }
    }
    static async submitKyc(req, res, next) {
        try {
            const { identityNumber } = req.body;
            if (!identityNumber || !/^\d{12}$/.test(identityNumber)) {
                res.status(400).json({ success: false, message: 'Invalid identity number' });
                return;
            }
            await database_1.default.user.update({
                where: { id: req.userId },
                data: {
                    kycStatus: 'PENDING',
                    identityNumber,
                },
            });
            (0, api_response_1.sendSuccess)(res, { message: 'KYC submitted successfully', kycStatus: 'PENDING' });
        }
        catch (err) {
            next(err);
        }
    }
}
exports.UsersController = UsersController;
//# sourceMappingURL=users.controller.js.map