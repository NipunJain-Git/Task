import dotenv from 'dotenv';
dotenv.config();

export const env = {
  PORT: parseInt(process.env.PORT || '3000', 10),
  NODE_ENV: process.env.NODE_ENV || 'development',
  JWT_SECRET: process.env.JWT_SECRET || 'kaamsetu-secret',
  JWT_REFRESH_SECRET: process.env.JWT_REFRESH_SECRET || 'kaamsetu-refresh',
  JWT_EXPIRY: process.env.JWT_EXPIRY || '7d',
  JWT_REFRESH_EXPIRY: process.env.JWT_REFRESH_EXPIRY || '30d',
  MOCK_OTP: process.env.MOCK_OTP || '123456',
  DATABASE_URL: process.env.DATABASE_URL || 'file:./dev.db',
};
