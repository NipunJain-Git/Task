import { Request, Response } from 'express';
export declare const getPlatformStats: (_req: Request, res: Response) => Promise<void>;
export declare const getPendingKycList: (_req: Request, res: Response) => Promise<void>;
export declare const updateKycStatus: (req: Request, res: Response) => Promise<Response<any, Record<string, any>> | undefined>;
//# sourceMappingURL=admin.controller.d.ts.map