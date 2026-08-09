import { GoogleGenerativeAI } from '@google/generative-ai';
import { env } from '../../config/env';

export class SupportService {
  static async chatWithGemini(message: string): Promise<string> {
    try {
      const apiKey = env.GEMINI_API_KEY;
      if (!apiKey) {
        return "Sorry, the AI chatbot is currently unavailable (API key missing).";
      }

      const genAI = new GoogleGenerativeAI(apiKey);
      const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

      const prompt = `You are a helpful customer support assistant for KaamSetu, a daily-wage hyperlocal job app. 
      Answer the user's question concisely and politely. Keep responses under 3 sentences.
      User message: ${message}`;

      const result = await model.generateContent(prompt);
      const response = await result.response;
      return response.text();
    } catch (error: any) {
      console.error('Gemini error:', error);
      return "I'm having trouble connecting right now. Please call Parth at +91 84339 27633.";
    }
  }
}
