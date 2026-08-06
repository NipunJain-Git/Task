import { Request, Response } from 'express';
import { WalletService } from './wallet.service';
import prisma from '../../config/database';

export class WalletController {
  static async getWallet(req: Request, res: Response) {
    try {
      const userId = req.user?.id;
      if (!userId) return res.status(401).json({ error: 'Unauthorized' });

      const wallet = await WalletService.getWallet(userId);
      const user = await prisma.user.findUnique({ where: { id: userId } });
      const hasPin = !!user?.walletPin;

      res.json({ wallet, hasPin });
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  static async setupPin(req: Request, res: Response) {
    try {
      const userId = req.user?.id;
      if (!userId) return res.status(401).json({ error: 'Unauthorized' });

      const { pin } = req.body;
      const result = await WalletService.setupPin(userId, pin);
      res.json(result);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  static async addMoney(req: Request, res: Response) {
    try {
      const userId = req.user?.id;
      if (!userId) return res.status(401).json({ error: 'Unauthorized' });

      const { amount, referenceId } = req.body;
      const result = await WalletService.addMoney(userId, amount, referenceId);
      res.json(result);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  static async transferToFamily(req: Request, res: Response) {
    try {
      const userId = req.user?.id;
      if (!userId) return res.status(401).json({ error: 'Unauthorized' });

      const { amount, pin } = req.body;
      const result = await WalletService.transferToFamily(userId, amount, pin);
      res.json(result);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  static async jobPayout(req: Request, res: Response) {
    try {
      const userId = req.user?.id;
      if (!userId) return res.status(401).json({ error: 'Unauthorized' });

      const { jobId, amount, pin } = req.body;
      const result = await WalletService.jobPayout(userId, jobId, amount, pin);
      res.json(result);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }
}
