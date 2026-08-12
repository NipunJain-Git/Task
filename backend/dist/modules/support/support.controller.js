"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SupportController = void 0;
const support_service_1 = require("./support.service");
class SupportController {
    static async chat(req, res) {
        try {
            const { message } = req.body;
            const reply = await support_service_1.SupportService.chatWithGemini(message);
            res.json({ reply });
        }
        catch (error) {
            res.status(500).json({ error: error.message });
        }
    }
}
exports.SupportController = SupportController;
//# sourceMappingURL=support.controller.js.map