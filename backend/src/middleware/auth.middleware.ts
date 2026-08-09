import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { env } from '../config/env';
import { ApiError } from '../utils/api-error';

export interface AuthRequest extends Request {
  userId?: string;
  userRole?: string;
}

export function authMiddleware(req: AuthRequest, _res: Response, next: NextFunction): void {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new ApiError(401, 'UNAUTHORIZED', 'Authentication token is required.');
  }

  const token = authHeader.split(' ')[1];
  try {
    const decoded = jwt.verify(token, env.JWT_SECRET) as { userId: string; role: string };
    req.userId = decoded.userId;
    req.userRole = decoded.role;
    next();
  } catch {
    throw new ApiError(401, 'TOKEN_EXPIRED', 'Authentication token is invalid or expired.');
  }
}

export function roleMiddleware(...roles: string[]) {
  return (req: AuthRequest, _res: Response, next: NextFunction): void => {
    if (!req.userRole || !roles.includes(req.userRole)) {
      throw new ApiError(403, 'FORBIDDEN', 'You do not have permission to perform this action.');
    }
    next();
  };
}
