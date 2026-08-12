import app from './index';
import { env } from './config/env';
import logger from './utils/logger';

app.listen(env.PORT, '0.0.0.0', () => {
  logger.info(`KaamSetu API server running on port ${env.PORT}`, { port: env.PORT, env: env.NODE_ENV });
});
