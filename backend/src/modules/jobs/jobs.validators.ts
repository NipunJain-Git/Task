import { z } from 'zod';

export const createJobSchema = z.object({
  title: z.string().min(3, 'Title must be at least 3 characters').max(100),
  description: z.string().min(10, 'Description must be at least 10 characters').max(1000),
  category: z.string().min(1, 'Category is required'),
  jobDate: z.string().refine(d => !isNaN(Date.parse(d)), 'Invalid date'),
  jobTime: z.string().optional(),
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180),
  address: z.string().optional(),
  budgetAmount: z.number().positive('Budget must be positive'),
  budgetType: z.enum(['FIXED', 'NEGOTIABLE']).default('FIXED'),
});

export const jobFiltersSchema = z.object({
  latitude: z.coerce.number().min(-90).max(90).optional(),
  longitude: z.coerce.number().min(-180).max(180).optional(),
  radius: z.coerce.number().min(1).max(100).default(10),
  category: z.string().optional(),
  status: z.string().default('OPEN'),
  page: z.coerce.number().int().positive().default(1),
  limit: z.coerce.number().int().positive().max(50).default(20),
});

export const updateJobStatusSchema = z.object({
  status: z.enum(['ASSIGNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED']),
});
