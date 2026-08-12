"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const path_1 = __importDefault(require("path"));
const env_1 = require("./config/env");
const error_middleware_1 = require("./middleware/error.middleware");
const auth_routes_1 = __importDefault(require("./modules/auth/auth.routes"));
const users_routes_1 = __importDefault(require("./modules/users/users.routes"));
const admin_routes_1 = __importDefault(require("./modules/admin/admin.routes"));
const jobs_routes_1 = __importDefault(require("./modules/jobs/jobs.routes"));
const interests_routes_1 = __importDefault(require("./modules/interests/interests.routes"));
const ratings_routes_1 = __importDefault(require("./modules/ratings/ratings.routes"));
const notifications_routes_1 = __importDefault(require("./modules/notifications/notifications.routes"));
const wallet_routes_1 = __importDefault(require("./modules/wallet/wallet.routes"));
const chat_routes_1 = __importDefault(require("./modules/chat/chat.routes"));
const kyc_routes_1 = __importDefault(require("./modules/kyc/kyc.routes"));
const logger_1 = __importDefault(require("./utils/logger"));
const firebase_1 = require("./config/firebase");
const app = (0, express_1.default)();
// Initialize Firebase Admin
(0, firebase_1.initFirebase)();
// Middleware
app.use((0, helmet_1.default)());
app.use((0, cors_1.default)());
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: true }));
app.use(express_1.default.static(path_1.default.join(__dirname, '../public')));
// Health check
app.get('/api/health', (_req, res) => {
    res.json({ success: true, data: { status: 'ok', timestamp: new Date().toISOString() } });
});
// Root route (for browser visits)
app.get('/', (_req, res) => {
    res.send(`
    <html>
      <body style="font-family: sans-serif; text-align: center; padding: 50px;">
        <h1 style="color: #4CAF50;">✅ KaamSetu Backend is Live!</h1>
        <p>The API is running perfectly. The Flutter app is ready to connect.</p>
        <p style="color: #888;">(This is the API server. There is no web frontend here.)</p>
      </body>
    </html>
  `);
});
// Routes
app.use('/api/auth', auth_routes_1.default);
app.use('/api/users', users_routes_1.default);
app.use('/api/admin', admin_routes_1.default);
app.use('/api/jobs', jobs_routes_1.default);
app.use('/api/jobs', interests_routes_1.default); // /api/jobs/:id/interest, /api/jobs/:id/applicants, /api/jobs/:id/assign
app.use('/api/jobs', ratings_routes_1.default); // /api/jobs/:id/rate
app.use('/api/notifications', notifications_routes_1.default);
app.use('/api/wallet', wallet_routes_1.default);
app.use('/api/chat', chat_routes_1.default);
app.use('/api/kyc', kyc_routes_1.default);
// Error handler (must be last)
app.use(error_middleware_1.errorMiddleware);
// Start server only if not running on Vercel
if (!process.env.VERCEL) {
    app.listen(env_1.env.PORT, '0.0.0.0', () => {
        logger_1.default.info(`KaamSetu API server running on port ${env_1.env.PORT}`, { port: env_1.env.PORT, env: env_1.env.NODE_ENV });
    });
}
exports.default = app;
//# sourceMappingURL=index.js.map