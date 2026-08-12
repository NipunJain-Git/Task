export declare class WalletService {
    static getWallet(userId: string): Promise<{
        transactions: {
            id: string;
            createdAt: Date;
            type: string;
            description: string | null;
            walletId: string;
            amount: number;
            receiptNumber: string;
            referenceId: string | null;
        }[];
    } & {
        id: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        balance: number;
    }>;
    static setupPin(userId: string, pin: string): Promise<{
        message: string;
    }>;
    static verifyPin(userId: string, pin: string): Promise<boolean>;
    static addMoney(userId: string, amount: number, referenceId?: string): Promise<{
        wallet: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            userId: string;
            balance: number;
        };
        transaction: {
            id: string;
            createdAt: Date;
            type: string;
            description: string | null;
            walletId: string;
            amount: number;
            receiptNumber: string;
            referenceId: string | null;
        };
    }>;
    static transferToFamily(userId: string, amount: number, pin: string): Promise<{
        wallet: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            userId: string;
            balance: number;
        };
        transaction: {
            id: string;
            createdAt: Date;
            type: string;
            description: string | null;
            walletId: string;
            amount: number;
            receiptNumber: string;
            referenceId: string | null;
        };
    }>;
    static jobPayout(userId: string, jobId: string, amount: number, pin: string): Promise<{
        debitTx: {
            id: string;
            createdAt: Date;
            type: string;
            description: string | null;
            walletId: string;
            amount: number;
            receiptNumber: string;
            referenceId: string | null;
        };
        creditTx: {
            id: string;
            createdAt: Date;
            type: string;
            description: string | null;
            walletId: string;
            amount: number;
            receiptNumber: string;
            referenceId: string | null;
        };
    }>;
}
//# sourceMappingURL=wallet.service.d.ts.map