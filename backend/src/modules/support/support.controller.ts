import { Request, Response } from 'express';
import { SupportService } from './support.service';

export class SupportController {
  static async chat(req: Request, res: Response) {
    try {
      const { message } = req.body;
      const reply = await SupportService.chatWithGemini(message);
      res.json({ reply });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }
}
