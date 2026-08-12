"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.env = void 0;
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
exports.env = {
    PORT: parseInt(process.env.PORT || '3000', 10),
    NODE_ENV: process.env.NODE_ENV || 'development',
    JWT_SECRET: process.env.JWT_SECRET || 'kaamsetu-secret',
    JWT_REFRESH_SECRET: process.env.JWT_REFRESH_SECRET || 'kaamsetu-refresh',
    JWT_EXPIRY: process.env.JWT_EXPIRY || '7d',
    JWT_REFRESH_EXPIRY: process.env.JWT_REFRESH_EXPIRY || '30d',
    MOCK_OTP: process.env.MOCK_OTP || '123456',
    DATABASE_URL: process.env.DATABASE_URL || 'file:./dev.db',
    GEMINI_API_KEY: process.env.GEMINI_API_KEY,
    TWO_FACTOR_API_KEY: process.env.TWO_FACTOR_API_KEY,
};
//# sourceMappingURL=env.js.map