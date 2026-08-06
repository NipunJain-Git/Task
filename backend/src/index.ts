import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import path from 'path';
import { env } from './config/env';
import { errorMiddleware } from './middleware/error.middleware';
import authRoutes from './modules/auth/auth.routes';
import usersRoutes from './modules/users/users.routes';
import jobsRoutes from './modules/jobs/jobs.routes';
import interestsRoutes from './modules/interests/interests.routes';
import ratingsRoutes from './modules/ratings/ratings.routes';
import notificationsRoutes from './modules/notifications/notifications.routes';
import walletRoutes from './modules/wallet/wallet.routes';
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

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', usersRoutes);
app.use('/api/jobs', jobsRoutes);
app.use('/api/jobs', interestsRoutes);  // /api/jobs/:id/interest, /api/jobs/:id/interests
app.use('/api/jobs', ratingsRoutes);    // /api/jobs/:id/rate
app.use('/api/notifications', notificationsRoutes);
app.use('/api/wallet', walletRoutes);

// Error handler (must be last)
app.use(errorMiddleware);

// Start server
app.listen(env.PORT, '0.0.0.0', () => {
  logger.info(`KaamSetu API server running on port ${env.PORT}`, { port: env.PORT, env: env.NODE_ENV });
});

export default app;
