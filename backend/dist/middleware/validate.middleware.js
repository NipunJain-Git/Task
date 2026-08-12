"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.validate = validate;
const api_error_1 = require("../utils/api-error");
function validate(schema, source = 'body') {
    return (req, _res, next) => {
        const result = schema.safeParse(req[source]);
        if (!result.success) {
            const message = result.error.errors.map(e => e.message).join(', ');
            throw new api_error_1.ApiError(400, 'VALIDATION_ERROR', message);
        }
        req[source] = result.data;
        next();
    };
}
//# sourceMappingURL=validate.middleware.js.map