"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.InterestsController = void 0;
const interests_service_1 = require("./interests.service");
const api_response_1 = require("../../utils/api-response");
class InterestsController {
    static async express(req, res, next) {
        try {
            const result = await interests_service_1.InterestsService.expressInterest(req.params.id, req.userId);
            (0, api_response_1.sendSuccess)(res, result, undefined, 201);
        }
        catch (err) {
            next(err);
        }
    }
    static async list(req, res, next) {
        try {
            const result = await interests_service_1.InterestsService.listInterestedWorkers(req.params.id, req.userId);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async acceptOrReject(req, res, next) {
        try {
            const result = await interests_service_1.InterestsService.acceptOrReject(req.params.id, req.params.interestId, req.userId, req.body.action);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
    static async myInterests(req, res, next) {
        try {
            const result = await interests_service_1.InterestsService.getMyInterests(req.userId);
            (0, api_response_1.sendSuccess)(res, result);
        }
        catch (err) {
            next(err);
        }
    }
}
exports.InterestsController = InterestsController;
//# sourceMappingURL=interests.controller.js.map