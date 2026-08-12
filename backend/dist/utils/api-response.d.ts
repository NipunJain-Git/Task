import { Response } from 'express';
interface PaginationMeta {
    page: number;
    limit: number;
    total: number;
}
export declare function sendSuccess(res: Response, data: unknown, meta?: PaginationMeta, statusCode?: number): void;
export declare function sendError(res: Response, statusCode: number, code: string, message: string): void;
export {};
//# sourceMappingURL=api-response.d.ts.map