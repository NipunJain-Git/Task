"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateJobStatusSchema = exports.jobFiltersSchema = exports.createJobSchema = void 0;
const zod_1 = require("zod");
exports.createJobSchema = zod_1.z.object({
    title: zod_1.z.string().min(3, 'Title must be at least 3 characters').max(100),
    description: zod_1.z.string().min(10, 'Description must be at least 10 characters').max(1000),
    category: zod_1.z.string().min(1, 'Category is required'),
    jobDate: zod_1.z.string().refine(d => !isNaN(Date.parse(d)), 'Invalid date'),
    jobTime: zod_1.z.string().optional(),
    latitude: zod_1.z.number().min(-90).max(90),
    longitude: zod_1.z.number().min(-180).max(180),
    address: zod_1.z.string().optional(),
    budgetAmount: zod_1.z.number().positive('Budget must be positive'),
    budgetType: zod_1.z.enum(['FIXED', 'NEGOTIABLE']).default('FIXED'),
});
exports.jobFiltersSchema = zod_1.z.object({
    latitude: zod_1.z.coerce.number().min(-90).max(90).optional(),
    longitude: zod_1.z.coerce.number().min(-180).max(180).optional(),
    radius: zod_1.z.coerce.number().min(1).max(100).default(10),
    category: zod_1.z.string().optional(),
    status: zod_1.z.string().default('OPEN'),
    page: zod_1.z.coerce.number().int().positive().default(1),
    limit: zod_1.z.coerce.number().int().positive().max(50).default(20),
});
exports.updateJobStatusSchema = zod_1.z.object({
    status: zod_1.z.enum(['ASSIGNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED']),
});
//# sourceMappingURL=jobs.validators.js.map