"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.WalletController = void 0;
const wallet_service_1 = require("./wallet.service");
const database_1 = __importDefault(require("../../config/database"));
class WalletController {
    static async getWallet(req, res) {
        try {
            const userId = req.userId;
            if (!userId)
                return res.status(401).json({ error: 'Unauthorized' });
            const wallet = await wallet_service_1.WalletService.getWallet(userId);
            const user = await database_1.default.user.findUnique({ where: { id: userId } });
            const hasPin = !!user?.walletPin;
            res.json({ wallet, hasPin });
        }
        catch (error) {
            res.status(400).json({ error: error.message });
        }
    }
    static async setupPin(req, res) {
        try {
            const userId = req.userId;
            if (!userId)
                return res.status(401).json({ error: 'Unauthorized' });
            const { pin } = req.body;
            const result = await wallet_service_1.WalletService.setupPin(userId, pin);
            res.json(result);
        }
        catch (error) {
            res.status(400).json({ error: error.message });
        }
    }
    static async addMoney(req, res) {
        try {
            const userId = req.userId;
            if (!userId)
                return res.status(401).json({ error: 'Unauthorized' });
            const { amount, referenceId } = req.body;
            const result = await wallet_service_1.WalletService.addMoney(userId, amount, referenceId);
            res.json(result);
        }
        catch (error) {
            res.status(400).json({ error: error.message });
        }
    }
    static async transferToFamily(req, res) {
        try {
            const userId = req.userId;
            if (!userId)
                return res.status(401).json({ error: 'Unauthorized' });
            const { amount, pin } = req.body;
            const result = await wallet_service_1.WalletService.transferToFamily(userId, amount, pin);
            res.json(result);
        }
        catch (error) {
            res.status(400).json({ error: error.message });
        }
    }
    static async jobPayout(req, res) {
        try {
            const userId = req.userId;
            if (!userId)
                return res.status(401).json({ error: 'Unauthorized' });
            const { jobId, amount, pin } = req.body;
            const result = await wallet_service_1.WalletService.jobPayout(userId, jobId, amount, pin);
            res.json(result);
        }
        catch (error) {
            res.status(400).json({ error: error.message });
        }
    }
}
exports.WalletController = WalletController;
//# sourceMappingURL=wallet.controller.js.map