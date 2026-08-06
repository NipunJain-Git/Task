import express from 'express';

let exportApp;
try {
  // Use require so we can catch any initialization errors
  const mainApp = require('../src/index').default;
  exportApp = mainApp;
} catch (error: any) {
  const errorApp = express();
  errorApp.all('*', (req, res) => {
    res.status(500).json({
      error: 'Vercel Initialization Error',
      message: error.message,
      stack: error.stack
    });
  });
  exportApp = errorApp;
}

export default exportApp;
