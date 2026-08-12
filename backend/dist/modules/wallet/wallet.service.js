"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.WalletService = void 0;
const database_1 = __importDefault(require("../../config/database"));
const bcryptjs_1 = __importDefault(require("bcryptjs"));
class WalletService {
    static async getWallet(userId) {
        let wallet = await database_1.default.wallet.findUnique({
            where: { userId },
            include: {
                transactions: {
                    orderBy: { createdAt: 'desc' },
                },
            },
        });
        if (!wallet) {
            wallet = await database_1.default.wallet.create({
                data: {
                    userId,
                    balance: 0.0,
                },
                include: {
                    transactions: true,
                },
            });
        }
        return wallet;
    }
    static async setupPin(userId, pin) {
        const hashedPin = await bcryptjs_1.default.hash(pin, 10);
        await database_1.default.user.update({
            where: { id: userId },
            data: { walletPin: hashedPin },
        });
        // Create wallet if it doesn't exist yet
        await this.getWallet(userId);
        return { message: 'PIN setup successful' };
    }
    static async verifyPin(userId, pin) {
        const user = await database_1.default.user.findUnique({ where: { id: userId } });
        if (!user || !user.walletPin) {
            throw new Error('PIN not set up');
        }
        const isValid = await bcryptjs_1.default.compare(pin, user.walletPin);
        if (!isValid) {
            throw new Error('Invalid PIN');
        }
        return true;
    }
    static async addMoney(userId, amount, referenceId) {
        const wallet = await this.getWallet(userId);
        const receiptNumber = `REC-${Math.floor(100000 + Math.random() * 900000)}`;
        const transaction = await database_1.default.$transaction(async (prisma) => {
            const updatedWallet = await prisma.wallet.update({
                where: { id: wallet.id },
                data: { balance: { increment: amount } },
            });
            const tx = await prisma.transaction.create({
                data: {
                    walletId: wallet.id,
                    amount,
                    type: 'CREDIT',
                    description: 'Added money to wallet',
                    receiptNumber,
                    referenceId,
                },
            });
            return { wallet: updatedWallet, transaction: tx };
        });
        return transaction;
    }
    static async transferToFamily(userId, amount, pin) {
        await this.verifyPin(userId, pin);
        const wallet = await this.getWallet(userId);
        if (wallet.balance < amount) {
            throw new Error('Insufficient balance');
        }
        const receiptNumber = `REC-${Math.floor(100000 + Math.random() * 900000)}`;
        const transaction = await database_1.default.$transaction(async (prisma) => {
            const updatedWallet = await prisma.wallet.update({
                where: { id: wallet.id },
                data: { balance: { decrement: amount } },
            });
            const tx = await prisma.transaction.create({
                data: {
                    walletId: wallet.id,
                    amount,
                    type: 'DEBIT',
                    description: 'Transferred to Family Member',
                    receiptNumber,
                },
            });
            return { wallet: updatedWallet, transaction: tx };
        });
        return transaction;
    }
    static async jobPayout(userId, jobId, amount, pin) {
        await this.verifyPin(userId, pin);
        const wallet = await this.getWallet(userId);
        if (wallet.balance < amount) {
            throw new Error('Insufficient balance for job payout');
        }
        // Get the job to find the assigned worker
        const job = await database_1.default.job.findUnique({
            where: { id: jobId },
            include: { assignedWorker: true },
        });
        if (!job || !job.assignedWorkerId) {
            throw new Error('Job or assigned worker not found');
        }
        // Process payout: Debit from Household, Credit to Worker
        const workerWallet = await this.getWallet(job.assignedWorkerId);
        const receiptNumberDebit = `REC-${Math.floor(100000 + Math.random() * 900000)}`;
        const receiptNumberCredit = `REC-${Math.floor(100000 + Math.random() * 900000)}`;
        const result = await database_1.default.$transaction(async (prisma) => {
            // 1. Debit Household
            await prisma.wallet.update({
                where: { id: wallet.id },
                data: { balance: { decrement: amount } },
            });
            const debitTx = await prisma.transaction.create({
                data: {
                    walletId: wallet.id,
                    amount,
                    type: 'DEBIT',
                    description: `Payout for job ${job.title}`,
                    receiptNumber: receiptNumberDebit,
                    referenceId: jobId,
                },
            });
            // 2. Credit Worker
            await prisma.wallet.update({
                where: { id: workerWallet.id },
                data: { balance: { increment: amount } },
            });
            const creditTx = await prisma.transaction.create({
                data: {
                    walletId: workerWallet.id,
                    amount,
                    type: 'CREDIT',
                    description: `Received payment for job ${job.title}`,
                    receiptNumber: receiptNumberCredit,
                    referenceId: jobId,
                },
            });
            // Update Job status
            await prisma.job.update({
                where: { id: jobId },
                data: { status: 'COMPLETED' }
            });
            return { debitTx, creditTx };
        });
        return result;
    }
}
exports.WalletService = WalletService;
//# sourceMappingURL=wallet.service.js.map