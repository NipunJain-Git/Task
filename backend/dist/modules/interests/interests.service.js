"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.InterestsService = void 0;
const database_1 = __importDefault(require("../../config/database"));
const api_error_1 = require("../../utils/api-error");
class InterestsService {
    static async expressInterest(jobId, workerId) {
        const job = await database_1.default.job.findUnique({ where: { id: jobId } });
        if (!job)
            throw new api_error_1.ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');
        if (job.status !== 'OPEN')
            throw new api_error_1.ApiError(400, 'JOB_NOT_OPEN', 'This job is no longer accepting interests.');
        // Check duplicate
        const existing = await database_1.default.jobInterest.findUnique({ where: { jobId_workerId: { jobId, workerId } } });
        if (existing)
            throw new api_error_1.ApiError(400, 'DUPLICATE_INTEREST', 'You have already expressed interest in this job.');
        // Check max 10 open interests
        const activeInterests = await database_1.default.jobInterest.count({
            where: { workerId, status: 'PENDING' },
        });
        if (activeInterests >= 10) {
            throw new api_error_1.ApiError(400, 'MAX_INTERESTS', 'You can only have 10 pending interests at a time.');
        }
        const interest = await database_1.default.jobInterest.create({
            data: { jobId, workerId },
            include: { worker: { select: { id: true, name: true, photoUrl: true } } },
        });
        // Create notification for household
        await database_1.default.notification.create({
            data: {
                userId: job.householdId,
                type: 'NEW_INTEREST',
                title: 'New Worker Interested',
                body: `A worker has expressed interest in your job "${job.title}".`,
                data: JSON.stringify({ jobId }),
            },
        });
        return interest;
    }
    static async listInterestedWorkers(jobId, userId) {
        const job = await database_1.default.job.findUnique({ where: { id: jobId } });
        if (!job)
            throw new api_error_1.ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');
        if (job.householdId !== userId)
            throw new api_error_1.ApiError(403, 'FORBIDDEN', 'Only the job poster can view interested workers.');
        const interests = await database_1.default.jobInterest.findMany({
            where: { jobId },
            include: {
                worker: {
                    select: {
                        id: true, name: true, photoUrl: true,
                        workerProfile: true,
                    },
                },
            },
            orderBy: { createdAt: 'desc' },
        });
        return interests.map(i => ({
            ...i,
            worker: {
                ...i.worker,
                workerProfile: i.worker.workerProfile ? {
                    ...i.worker.workerProfile,
                    skills: JSON.parse(i.worker.workerProfile.skills || '[]'),
                } : null,
            },
        }));
    }
    static async acceptOrReject(jobId, interestId, userId, action) {
        const job = await database_1.default.job.findUnique({ where: { id: jobId } });
        if (!job)
            throw new api_error_1.ApiError(404, 'JOB_NOT_FOUND', 'Job not found.');
        if (job.householdId !== userId)
            throw new api_error_1.ApiError(403, 'FORBIDDEN', 'Only the job poster can accept/reject workers.');
        const interest = await database_1.default.jobInterest.findUnique({ where: { id: interestId } });
        if (!interest)
            throw new api_error_1.ApiError(404, 'INTEREST_NOT_FOUND', 'Interest not found.');
        if (action === 'ACCEPTED') {
            // Accept this worker, reject all others, assign job
            await database_1.default.$transaction([
                database_1.default.jobInterest.update({ where: { id: interestId }, data: { status: 'ACCEPTED' } }),
                database_1.default.jobInterest.updateMany({
                    where: { jobId, id: { not: interestId } },
                    data: { status: 'REJECTED' },
                }),
                database_1.default.job.update({
                    where: { id: jobId },
                    data: { status: 'ASSIGNED', assignedWorkerId: interest.workerId },
                }),
            ]);
            // Notify accepted worker
            await database_1.default.notification.create({
                data: {
                    userId: interest.workerId,
                    type: 'SELECTED',
                    title: 'You\'ve Been Selected!',
                    body: `You have been selected for the job "${job.title}".`,
                    data: JSON.stringify({ jobId }),
                },
            });
        }
        else {
            await database_1.default.jobInterest.update({ where: { id: interestId }, data: { status: 'REJECTED' } });
        }
        return { success: true };
    }
    static async getMyInterests(workerId) {
        return database_1.default.jobInterest.findMany({
            where: { workerId },
            include: {
                job: {
                    select: {
                        id: true, title: true, category: true, status: true,
                        budgetAmount: true, budgetType: true, jobDate: true, address: true,
                        household: { select: { id: true, name: true, photoUrl: true } },
                    },
                },
            },
            orderBy: { createdAt: 'desc' },
        });
    }
}
exports.InterestsService = InterestsService;
//# sourceMappingURL=interests.service.js.map