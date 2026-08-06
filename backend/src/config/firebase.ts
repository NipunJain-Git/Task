import * as admin from 'firebase-admin';
import * as path from 'path';
import logger from '../utils/logger';

export const initFirebase = () => {
  try {
    if (process.env.FIREBASE_SERVICE_ACCOUNT_JSON) {
      const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_JSON);
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
      logger.info('Firebase Admin SDK initialized successfully from environment variable');
    } else {
      const serviceAccountPath = path.resolve(__dirname, '../../firebase-service-account.json');
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccountPath),
      });
      logger.info('Firebase Admin SDK initialized successfully from file');
    }
  } catch (error) {
    logger.error('Failed to initialize Firebase Admin SDK', { error });
    // Don't throw, just log. If Firebase fails, auth middleware will catch it later.
  }
};
