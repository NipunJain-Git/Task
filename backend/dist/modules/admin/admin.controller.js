"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateKycStatus = exports.getPendingKycList = exports.getPlatformStats = void 0;
const database_1 = __importDefault(require("../../config/database"));
const getPlatformStats = async (_req, res) => {
    try {
        const totalUsers = await database_1.default.user.count();
        const totalJobs = await database_1.default.job.count();
        const totalCities = await database_1.default.city.count();
        const pendingKycCount = await database_1.default.user.count({
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
    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};
exports.getPlatformStats = getPlatformStats;
const getPendingKycList = async (_req, res) => {
    try {
        const users = await database_1.default.user.findMany({
            where: { kycStatus: 'PENDING', kycDocumentUrl: { not: null } },
            select: { id: true, name: true, phone: true, role: true, kycDocumentUrl: true, createdAt: true }
        });
        res.json({ success: true, data: users });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};
exports.getPendingKycList = getPendingKycList;
const updateKycStatus = async (req, res) => {
    try {
        const { userId } = req.params;
        const { status } = req.body; // 'APPROVED' or 'REJECTED'
        if (!['APPROVED', 'REJECTED'].includes(status)) {
            return res.status(400).json({ success: false, message: 'Invalid status' });
        }
        const user = await database_1.default.user.update({
            where: { id: userId },
            data: { kycStatus: status }
        });
        res.json({ success: true, data: { userId: user.id, status: user.kycStatus } });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};
exports.updateKycStatus = updateKycStatus;
//# sourceMappingURL=admin.controller.js.map