import * as admin from 'firebase-admin';
import logger from './logger';

export async function sendPushNotification({
  fcmToken,
  title,
  body,
  data = {},
}: {
  fcmToken: string;
  title: string;
  body: string;
  data?: Record<string, string>;
}): Promise<void> {
  try {
    await admin.messaging().send({
      token: fcmToken,
      notification: { title, body },
      data,
      android: {
        priority: 'high',
        notification: { channelId: 'kaamsetu_default', sound: 'default' },
      },
    });
    logger.info('FCM notification sent', { fcmToken: fcmToken.slice(0, 20), title });
  } catch (error) {
    logger.error('FCM send failed', { error });
    // Don't throw - FCM failure should not break the main flow
  }
}
