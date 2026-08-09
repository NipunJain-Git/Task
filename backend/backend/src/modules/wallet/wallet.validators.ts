import { z } from 'zod';

export const setupPinSchema = z.object({
  pin: z.string().length(4, 'PIN must be exactly 4 digits').regex(/^\d+$/, 'PIN must contain only numbers'),
});

export const addMoneySchema = z.object({
  amount: z.number().positive('Amount must be positive'),
  referenceId: z.string().optional(),
});

export const transferToFamilySchema = z.object({
  amount: z.number().positive('Amount must be positive'),
  pin: z.string().length(4, 'PIN must be exactly 4 digits'),
});

export const jobPayoutSchema = z.object({
  jobId: z.string().uuid('Invalid Job ID'),
  amount: z.number().positive('Amount must be positive'),
  pin: z.string().length(4, 'PIN must be exactly 4 digits'),
});
