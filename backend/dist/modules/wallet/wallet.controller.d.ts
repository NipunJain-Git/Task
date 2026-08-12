import { Response } from 'express';
import { AuthRequest } from '../../middleware/auth.middleware';
export declare class WalletController {
    static getWallet(req: AuthRequest, res: Response): Promise<Response<any, Record<string, any>> | undefined>;
    static setupPin(req: AuthRequest, res: Response): Promise<Response<any, Record<string, any>> | undefined>;
    static addMoney(req: AuthRequest, res: Response): Promise<Response<any, Record<string, any>> | undefined>;
    static transferToFamily(req: AuthRequest, res: Response): Promise<Response<any, Record<string, any>> | undefined>;
    static jobPayout(req: AuthRequest, res: Response): Promise<Response<any, Record<string, any>> | undefined>;
}
//# sourceMappingURL=wallet.controller.d.ts.map