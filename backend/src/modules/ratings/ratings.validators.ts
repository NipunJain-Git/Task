import { z } from 'zod';

export const submitRatingSchema = z.object({
  value: z.enum(['THUMBS_UP', 'THUMBS_DOWN']),
  comment: z.string().max(150, 'Comment must be 150 characters or less').optional(),
});
