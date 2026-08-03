import { z } from 'zod';

export const sendOtpSchema = z.object({
  phone: z.string().min(10, 'Phone number must be at least 10 digits').max(15, 'Phone number too long'),
});

export const verifyOtpSchema = z.object({
  phone: z.string().min(10).max(15),
  otp: z.string().length(6, 'OTP must be 6 digits'),
});

export const selectRoleSchema = z.object({
  role: z.enum(['WORKER', 'HOUSEHOLD'], { message: 'Role must be WORKER or HOUSEHOLD' }),
});
