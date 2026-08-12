"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.RatingsService = void 0;
const database_1 = __importDefault(require("../../config/database"));
const api_error_1 = require("../../utils/api-error");
class RatingsService {
    static async submitRating(jobId, raterId, data) {
        const job = await database_1.default.job.findUnique({ where: { id: jobId } });
        if (!job)
            throw new api_error_1.ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');
        if (job.status !== 'COMPLETED')
            throw new api_error_1.ApiError(400, 'JOB_NOT_COMPLETED', 'You can only rate after the job is completed.');
        // Determine who is being rated
        let ratedUserId;
        if (raterId === job.householdId) {
            ratedUserId = job.assignedWorkerId;
        }
        else if (raterId === job.assignedWorkerId) {
            ratedUserId = job.householdId;
        }
        else {
            throw new api_error_1.ApiError(403, 'FORBIDDEN', 'You are not part of this job.');
        }
        // Check duplicate rating
        const existing = await database_1.default.rating.findUnique({ where: { jobId_raterId: { jobId, raterId } } });
        if (existing)
            throw new api_error_1.ApiError(400, 'ALREADY_RATED', 'You have already rated for this job.');
        const rating = await database_1.default.rating.create({
            data: { jobId, raterId, ratedUserId, value: data.value, comment: data.comment },
        });
        // Update profile counters
        const ratedUser = await database_1.default.user.findUnique({ where: { id: ratedUserId } });
        if (ratedUser?.role === 'WORKER') {
            const field = data.value === 'THUMBS_UP' ? 'thumbsUp' : 'thumbsDown';
            await database_1.default.workerProfile.update({
                where: { userId: ratedUserId },
                data: { [field]: { increment: 1 } },
            });
        }
        else if (ratedUser?.role === 'HOUSEHOLD') {
            const field = data.value === 'THUMBS_UP' ? 'thumbsUp' : 'thumbsDown';
            await database_1.default.householdProfile.update({
                where: { userId: ratedUserId },
                data: { [field]: { increment: 1 } },
            });
        }
        return rating;
    }
}
exports.RatingsService = RatingsService;
//# sourceMappingURL=ratings.service.js.map