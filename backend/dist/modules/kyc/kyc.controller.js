"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getKycStatus = exports.uploadKyc = void 0;
const database_1 = __importDefault(require("../../config/database"));
const uploadKyc = async (req, res) => {
    try {
        const { userId, documentUrl } = req.body;
        if (!userId || !documentUrl) {
            return res.status(400).json({ success: false, message: 'Missing required fields' });
        }
        const updatedUser = await database_1.default.user.update({
            where: { id: userId },
            data: {
                kycStatus: 'PENDING',
                kycDocumentUrl: documentUrl,
            },
        });
        res.json({ success: true, data: updatedUser });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};
exports.uploadKyc = uploadKyc;
const getKycStatus = async (req, res) => {
    try {
        const { userId } = req.params;
        const user = await database_1.default.user.findUnique({ where: { id: userId } });
        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }
        res.json({ success: true, data: { status: user.kycStatus, documentUrl: user.kycDocumentUrl } });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};
exports.getKycStatus = getKycStatus;
//# sourceMappingURL=kyc.controller.js.map