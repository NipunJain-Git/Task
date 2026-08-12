"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const index_1 = __importDefault(require("./index"));
const env_1 = require("./config/env");
const logger_1 = __importDefault(require("./utils/logger"));
index_1.default.listen(env_1.env.PORT, '0.0.0.0', () => {
    logger_1.default.info(`KaamSetu API server running on port ${env_1.env.PORT}`, { port: env_1.env.PORT, env: env_1.env.NODE_ENV });
});
//# sourceMappingURL=server.js.map