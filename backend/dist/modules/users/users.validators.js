"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.toggleAvailabilitySchema = exports.updateHouseholdProfileSchema = exports.updateWorkerProfileSchema = exports.updateProfileSchema = void 0;
const zod_1 = require("zod");
exports.updateProfileSchema = zod_1.z.object({
    name: zod_1.z.string().min(2, 'Name must be at least 2 characters').max(100).optional(),
    language: zod_1.z.enum(['en', 'hi']).optional(),
    latitude: zod_1.z.number().min(-90).max(90).optional(),
    longitude: zod_1.z.number().min(-180).max(180).optional(),
});
exports.updateWorkerProfileSchema = zod_1.z.object({
    skills: zod_1.z.array(zod_1.z.string()).min(1, 'At least one skill is required').optional(),
    expectedWage: zod_1.z.number().positive('Wage must be positive').optional(),
    wageType: zod_1.z.enum(['DAILY', 'HOURLY']).optional(),
    workRadius: zod_1.z.number().min(1).max(50).optional(),
});
exports.updateHouseholdProfileSchema = zod_1.z.object({
    address: zod_1.z.string().min(5, 'Address must be at least 5 characters').max(500).optional(),
});
exports.toggleAvailabilitySchema = zod_1.z.object({
    isAvailable: zod_1.z.boolean(),
});
//# sourceMappingURL=users.validators.js.map