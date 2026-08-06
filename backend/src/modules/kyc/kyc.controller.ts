import { Request, Response } from 'express';
import { prisma } from '../../config/database';

export const uploadKyc = async (req: Request, res: Response) => {
  try {
    const { userId, documentUrl } = req.body;
    if (!userId || !documentUrl) {
      return res.status(400).json({ success: false, message: 'Missing required fields' });
    }

    const updatedUser = await prisma.user.update({
      where: { id: userId },
      data: {
        kycStatus: 'PENDING',
        kycDocumentUrl: documentUrl,
      },
    });

    res.json({ success: true, data: updatedUser });
  } catch (error) {
    res.status(500).json({ success: false, error: (error as Error).message });
  }
};

export const getKycStatus = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const user = await prisma.user.findUnique({ where: { id: userId } });
    
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    res.json({ success: true, data: { status: user.kycStatus, documentUrl: user.kycDocumentUrl } });
  } catch (error) {
    res.status(500).json({ success: false, error: (error as Error).message });
  }
};
