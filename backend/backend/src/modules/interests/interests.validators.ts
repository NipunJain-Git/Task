import { z } from 'zod';

export const acceptRejectSchema = z.object({
  action: z.enum(['ACCEPTED', 'REJECTED']),
});
