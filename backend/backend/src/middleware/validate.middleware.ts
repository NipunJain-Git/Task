import { Request, Response, NextFunction } from 'express';
import { ZodSchema } from 'zod';
import { ApiError } from '../utils/api-error';

export function validate(schema: ZodSchema, source: 'body' | 'query' | 'params' = 'body') {
  return (req: Request, _res: Response, next: NextFunction): void => {
    const result = schema.safeParse(req[source]);
    if (!result.success) {
      const message = result.error.errors.map(e => e.message).join(', ');
      throw new ApiError(400, 'VALIDATION_ERROR', message);
    }
    req[source] = result.data;
    next();
  };
}
