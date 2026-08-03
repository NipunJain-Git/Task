import { Request, Response, NextFunction } from 'express';
import { ApiError } from '../utils/api-error';
import logger from '../utils/logger';

export function errorMiddleware(err: Error, _req: Request, res: Response, _next: NextFunction): void {
  logger.error(err.message, { stack: err.stack, name: err.name });

  if (err instanceof ApiError) {
    res.status(err.statusCode).json({
      success: false,
      error: {
        code: err.code,
        message: err.message,
        statusCode: err.statusCode,
      },
    });
    return;
  }

  res.status(500).json({
    success: false,
    error: {
      code: 'INTERNAL_ERROR',
      message: 'An unexpected error occurred.',
      statusCode: 500,
    },
  });
}
