"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RatingsController = void 0;
const ratings_service_1 = require("./ratings.service");
const api_response_1 = require("../../utils/api-response");
class RatingsController {
    static async submit(req, res, next) {
        try {
            const result = await ratings_service_1.RatingsService.submitRating(req.params.id, req.userId, req.body);
            (0, api_response_1.sendSuccess)(res, result, undefined, 201);
        }
        catch (err) {
            next(err);
        }
    }
}
exports.RatingsController = RatingsController;
//# sourceMappingURL=ratings.controller.js.map