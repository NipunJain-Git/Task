"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.submitRatingSchema = void 0;
const zod_1 = require("zod");
exports.submitRatingSchema = zod_1.z.object({
    value: zod_1.z.enum(['THUMBS_UP', 'THUMBS_DOWN']),
    comment: zod_1.z.string().max(150, 'Comment must be 150 characters or less').optional(),
});
//# sourceMappingURL=ratings.validators.js.map