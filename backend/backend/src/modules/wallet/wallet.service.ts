import prisma from '../../config/database';
import bcrypt from 'bcryptjs';
import { v4 as uuidv4 } from 'uuid';

export class WalletService {
  static async getWallet(userId: string) {
    let wallet = await prisma.wallet.findUnique({
      where: { userId },
      include: {
        transactions: {
          orderBy: { createdAt: 'desc' },
        },
      },
    });

    if (!wallet) {
      wallet = await prisma.wallet.create({
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

  static async setupPin(userId: string, pin: string) {
    const hashedPin = await bcrypt.hash(pin, 10);
    await prisma.user.update({
      where: { id: userId },
      data: { walletPin: hashedPin },
    });
    
    // Create wallet if it doesn't exist yet
    await this.getWallet(userId);
    return { message: 'PIN setup successful' };
  }

  static async verifyPin(userId: string, pin: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user || !user.walletPin) {
      throw new Error('PIN not set up');
    }
    const isValid = await bcrypt.compare(pin, user.walletPin);
    if (!isValid) {
      throw new Error('Invalid PIN');
    }
    return true;
  }

  static async addMoney(userId: string, amount: number, referenceId?: string) {
    const wallet = await this.getWallet(userId);
    const receiptNumber = `REC-${Math.floor(100000 + Math.random() * 900000)}`;

    const transaction = await prisma.$transaction(async (prisma) => {
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

  static async transferToFamily(userId: string, amount: number, pin: string) {
    await this.verifyPin(userId, pin);
    const wallet = await this.getWallet(userId);
    
    if (wallet.balance < amount) {
      throw new Error('Insufficient balance');
    }

    const receiptNumber = `REC-${Math.floor(100000 + Math.random() * 900000)}`;

    const transaction = await prisma.$transaction(async (prisma) => {
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

  static async jobPayout(userId: string, jobId: string, amount: number, pin: string) {
    await this.verifyPin(userId, pin);
    const wallet = await this.getWallet(userId);

    if (wallet.balance < amount) {
      throw new Error('Insufficient balance for job payout');
    }

    // Get the job to find the assigned worker
    const job = await prisma.job.findUnique({
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

    const result = await prisma.$transaction(async (prisma) => {
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
