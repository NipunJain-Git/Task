"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.acceptRejectSchema = void 0;
const zod_1 = require("zod");
exports.acceptRejectSchema = zod_1.z.object({
    action: zod_1.z.enum(['ACCEPTED', 'REJECTED']),
});
//# sourceMappingURL=interests.validators.js.map