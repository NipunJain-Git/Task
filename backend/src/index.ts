import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import path from 'path';
import { env } from './config/env';
import { errorMiddleware } from './middleware/error.middleware';
import authRoutes from './modules/auth/auth.routes';
import usersRoutes from './modules/users/users.routes';
import adminRoutes from './modules/admin/admin.routes';
import jobsRoutes from './modules/jobs/jobs.routes';
import interestsRoutes from './modules/interests/interests.routes';
import ratingsRoutes from './modules/ratings/ratings.routes';
import notificationsRoutes from './modules/notifications/notifications.routes';
import walletRoutes from './modules/wallet/wallet.routes';
import chatRoutes from './modules/chat/chat.routes';
import kycRoutes from './modules/kyc/kyc.routes';
import logger from './utils/logger';
import { initFirebase } from './config/firebase';

const app = express();

// Initialize Firebase Admin
initFirebase();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, '../public')));

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
app.use('/api/auth', authRoutes);
app.use('/api/users', usersRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/jobs', jobsRoutes);
app.use('/api/jobs', interestsRoutes);  // /api/jobs/:id/interest, /api/jobs/:id/applicants, /api/jobs/:id/assign
app.use('/api/jobs', ratingsRoutes);    // /api/jobs/:id/rate
app.use('/api/notifications', notificationsRoutes);
app.use('/api/wallet', walletRoutes);
app.use('/api/chat', chatRoutes);
app.use('/api/kyc', kycRoutes);

// Error handler (must be last)
app.use(errorMiddleware);

// Serverless export
export default app;
