"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.JobsController = void 0;
const jobs_service_1 = require("./jobs.service");
const api_response_1 = require("../../utils/api-response");
class JobsController {
    static async create(req, res, next) {
        try {
            const result = await jobs_service_1.JobsService.createJob(req.userId, req.body);
            (0, api_response_1.sendSuccess)(res, result, undefined, 201);
        }
        catch (err) {
            next(err);
        }
    }
    static async list(req, res, next) {
        try {
            const result = await jobs_service_1.JobsService.listJobs(req.query);
            (0, api_response_1.sendSuccess)(res, result.jobs, result.meta);
        }
        catch (err) {
            next(err);
        }
    }
    static async getById(req, res, next) {
        try {
            const result = await jobs_service_1.JobsService.getJobById(req.params.id);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async cancel(req, res, next) {
        try {
            const result = await jobs_service_1.JobsService.cancelJob(req.params.id, req.userId);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async myPosts(req, res, next) {
        try {
            const result = await jobs_service_1.JobsService.getMyPosts(req.userId);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async updateStatus(req, res, next) {
        try {
            const job = await jobs_service_1.JobsService.updateJobStatus(req.params.id, req.userId, req.body.status);
            (0, api_response_1.sendSuccess)(res, job);
        }
        catch (err) {
            next(err);
        }
    }
    static async apply(req, res, next) {
        try {
            const interest = await jobs_service_1.JobsService.applyForJob(req.params.id, req.userId);
            (0, api_response_1.sendSuccess)(res, interest);
        }
        catch (err) {
            next(err);
        }
    }
    static async getApplicants(req, res, next) {
        try {
            const applicants = await jobs_service_1.JobsService.getApplicants(req.params.id, req.userId);
            (0, api_response_1.sendSuccess)(res, applicants);
        }
        catch (err) {
            next(err);
        }
    }
    static async assignWorker(req, res, next) {
        try {
            const { workerId } = req.body;
            const job = await jobs_service_1.JobsService.assignWorker(req.params.id, req.userId, workerId);
            (0, api_response_1.sendSuccess)(res, job);
        }
        catch (err) {
            next(err);
        }
    }
}
exports.JobsController = JobsController;
//# sourceMappingURL=jobs.controller.js.map