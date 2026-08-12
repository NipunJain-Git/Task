import serverless from 'serverless-http';
import app from '../../src/index';

let slsHandler: any;

export const handler = async (event: any, context: any) => {
  try {
    if (!slsHandler) {
      const expressApp = (app as any).default || app;
      if (!expressApp || typeof expressApp.use !== 'function') {
        throw new Error(`Invalid Express app exported: ${typeof expressApp}`);
      }
      slsHandler = serverless(expressApp);
    }
    return await slsHandler(event, context);
  } catch (err: any) {
    return {
      statusCode: 502,
      body: JSON.stringify({
        error: err.message,
        stack: err.stack,
        appType: typeof app,
        keys: app ? Object.keys(app) : []
      })
    };
  }
};
