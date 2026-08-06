import { Request, Response } from 'express';
import { prisma } from '../../config/database';

export const getPlatformStats = async (_req: Request, res: Response) => {
  try {
    const totalUsers = await prisma.user.count();
    const totalJobs = await prisma.job.count();
    const totalCities = await prisma.city.count();
    
    const pendingKycCount = await prisma.user.count({
      where: { kycStatus: 'PENDING', kycDocumentUrl: { not: null } }
    });

    res.json({
      success: true,
      data: {
        totalUsers,
        totalJobs,
        totalCities,
        pendingKycCount
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, error: (error as Error).message });
  }
};

export const getPendingKycList = async (_req: Request, res: Response) => {
  try {
    const users = await prisma.user.findMany({
      where: { kycStatus: 'PENDING', kycDocumentUrl: { not: null } },
      select: { id: true, name: true, phone: true, role: true, kycDocumentUrl: true, createdAt: true }
    });
    res.json({ success: true, data: users });
  } catch (error) {
    res.status(500).json({ success: false, error: (error as Error).message });
  }
};

export const updateKycStatus = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const { status } = req.body; // 'APPROVED' or 'REJECTED'

    if (!['APPROVED', 'REJECTED'].includes(status)) {
      return res.status(400).json({ success: false, message: 'Invalid status' });
    }

    const user = await prisma.user.update({
      where: { id: userId },
      data: { kycStatus: status }
    });

    res.json({ success: true, data: { userId: user.id, status: user.kycStatus } });
  } catch (error) {
    res.status(500).json({ success: false, error: (error as Error).message });
  }
};
