"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UsersService = void 0;
const database_1 = __importDefault(require("../../config/database"));
const api_error_1 = require("../../utils/api-error");
class UsersService {
    static async getMe(userId) {
        const user = await database_1.default.user.findUnique({
            where: { id: userId },
            include: { workerProfile: true, householdProfile: true },
        });
        if (!user)
            throw new api_error_1.ApiError(404, 'USER_NOT_FOUND', 'User not found.');
        const result = { ...user };
        if (user.workerProfile) {
            result.workerProfile = {
                ...user.workerProfile,
                skills: JSON.parse(user.workerProfile.skills || '[]'),
            };
        }
        return result;
    }
    static async updateProfile(userId, data) {
        return database_1.default.user.update({ where: { id: userId }, data });
    }
    static async updateWorkerProfile(userId, data) {
        const updateData = {};
        if (data.skills)
            updateData.skills = JSON.stringify(data.skills);
        if (data.expectedWage !== undefined)
            updateData.expectedWage = data.expectedWage;
        if (data.wageType)
            updateData.wageType = data.wageType;
        if (data.workRadius !== undefined)
            updateData.workRadius = data.workRadius;
        return database_1.default.workerProfile.update({
            where: { userId },
            data: updateData,
        });
    }
    static async updateHouseholdProfile(userId, data) {
        return database_1.default.householdProfile.update({
            where: { userId },
            data,
        });
    }
    static async toggleAvailability(userId, isAvailable) {
        return database_1.default.workerProfile.update({
            where: { userId },
            data: { isAvailable },
        });
    }
    static async getUserById(id) {
        const user = await database_1.default.user.findUnique({
            where: { id },
            include: { workerProfile: true, householdProfile: true },
        });
        if (!user)
            throw new api_error_1.ApiError(404, 'USER_NOT_FOUND', 'User not found.');
        // Mask phone for privacy
        const result = {
            ...user,
            phone: user.phone.replace(/(\d{2})\d+(\d{2})/, '$1****$2'),
        };
        if (user.workerProfile) {
            result.workerProfile = {
                ...user.workerProfile,
                skills: JSON.parse(user.workerProfile.skills || '[]'),
            };
        }
        return result;
    }
    static async getRatingSummary(userId) {
        const ratings = await database_1.default.rating.findMany({
            where: { ratedUserId: userId },
            orderBy: { createdAt: 'desc' },
            take: 10,
            include: { rater: { select: { name: true, photoUrl: true } } },
        });
        const total = ratings.length;
        const allRatings = await database_1.default.rating.findMany({ where: { ratedUserId: userId } });
        const thumbsUp = allRatings.filter(r => r.value === 'THUMBS_UP').length;
        const thumbsDown = allRatings.filter(r => r.value === 'THUMBS_DOWN').length;
        const totalAll = allRatings.length;
        const positivePercent = totalAll > 0 ? Math.round((thumbsUp / totalAll) * 100) : 0;
        return {
            thumbsUp,
            thumbsDown,
            total: totalAll,
            positivePercent,
            recentRatings: ratings,
        };
    }
}
exports.UsersService = UsersService;
//# sourceMappingURL=users.service.js.map