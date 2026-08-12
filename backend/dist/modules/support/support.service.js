"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SupportService = void 0;
const generative_ai_1 = require("@google/generative-ai");
const env_1 = require("../../config/env");
class SupportService {
    static async chatWithGemini(message) {
        try {
            const apiKey = env_1.env.GEMINI_API_KEY;
            if (!apiKey) {
                return "Sorry, the AI chatbot is currently unavailable (API key missing).";
            }
            const genAI = new generative_ai_1.GoogleGenerativeAI(apiKey);
            const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
            const prompt = `You are a helpful customer support assistant for KaamSetu, a daily-wage hyperlocal job app. 
      Answer the user's question concisely and politely. Keep responses under 3 sentences.
      User message: ${message}`;
            const result = await model.generateContent(prompt);
            const response = await result.response;
            return response.text();
        }
        catch (error) {
            console.error('Gemini error:', error);
            return "I'm having trouble connecting right now. Please call Parth at +91 84339 27633.";
        }
    }
}
exports.SupportService = SupportService;
//# sourceMappingURL=support.service.js.map