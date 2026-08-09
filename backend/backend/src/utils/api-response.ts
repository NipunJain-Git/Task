import { Response } from 'express';

interface PaginationMeta {
  page: number;
  limit: number;
  total: number;
}

export function sendSuccess(res: Response, data: unknown, meta?: PaginationMeta, statusCode = 200): void {
  const response: Record<string, unknown> = { success: true, data };
  if (meta) {
    response.meta = meta;
  }
  res.status(statusCode).json(response);
}

export function sendError(res: Response, statusCode: number, code: string, message: string): void {
  res.status(statusCode).json({
    success: false,
    error: { code, message, statusCode },
  });
}
