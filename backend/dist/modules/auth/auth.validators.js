"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.selectRoleSchema = exports.verifyOtpSchema = exports.sendOtpSchema = void 0;
const zod_1 = require("zod");
exports.sendOtpSchema = zod_1.z.object({
    phone: zod_1.z.string().min(10, 'Phone number must be at least 10 digits').max(15, 'Phone number too long'),
});
exports.verifyOtpSchema = zod_1.z.object({
    phone: zod_1.z.string().min(10).max(15),
    otp: zod_1.z.string().length(6, 'OTP must be 6 digits'),
    sessionId: zod_1.z.string().optional(),
    role: zod_1.z.string().optional(),
});
exports.selectRoleSchema = zod_1.z.object({
    role: zod_1.z.enum(['WORKER', 'HOUSEHOLD'], { message: 'Role must be WORKER or HOUSEHOLD' }),
    familyMemberContact: zod_1.z.string().min(10).max(15).optional(),
    familyMemberRelation: zod_1.z.string().optional(),
});
//# sourceMappingURL=auth.validators.js.map