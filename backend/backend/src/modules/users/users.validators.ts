import { z } from 'zod';

export const updateProfileSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters').max(100).optional(),
  language: z.enum(['en', 'hi']).optional(),
  latitude: z.number().min(-90).max(90).optional(),
  longitude: z.number().min(-180).max(180).optional(),
});

export const updateWorkerProfileSchema = z.object({
  skills: z.array(z.string()).min(1, 'At least one skill is required').optional(),
  expectedWage: z.number().positive('Wage must be positive').optional(),
  wageType: z.enum(['DAILY', 'HOURLY']).optional(),
  workRadius: z.number().min(1).max(50).optional(),
});

export const updateHouseholdProfileSchema = z.object({
  address: z.string().min(5, 'Address must be at least 5 characters').max(500).optional(),
});

export const toggleAvailabilitySchema = z.object({
  isAvailable: z.boolean(),
});
