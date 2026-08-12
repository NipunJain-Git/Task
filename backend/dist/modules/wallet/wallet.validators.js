"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.jobPayoutSchema = exports.transferToFamilySchema = exports.addMoneySchema = exports.setupPinSchema = void 0;
const zod_1 = require("zod");
exports.setupPinSchema = zod_1.z.object({
    pin: zod_1.z.string().length(4, 'PIN must be exactly 4 digits').regex(/^\d+$/, 'PIN must contain only numbers'),
});
exports.addMoneySchema = zod_1.z.object({
    amount: zod_1.z.number().positive('Amount must be positive'),
    referenceId: zod_1.z.string().optional(),
});
exports.transferToFamilySchema = zod_1.z.object({
    amount: zod_1.z.number().positive('Amount must be positive'),
    pin: zod_1.z.string().length(4, 'PIN must be exactly 4 digits'),
});
exports.jobPayoutSchema = zod_1.z.object({
    jobId: zod_1.z.string().uuid('Invalid Job ID'),
    amount: zod_1.z.number().positive('Amount must be positive'),
    pin: zod_1.z.string().length(4, 'PIN must be exactly 4 digits'),
});
//# sourceMappingURL=wallet.validators.js.map