"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.initFirebase = void 0;
const admin = __importStar(require("firebase-admin"));
const path = __importStar(require("path"));
const fs = __importStar(require("fs"));
const logger_1 = __importDefault(require("../utils/logger"));
const initFirebase = () => {
    try {
        if (process.env.FIREBASE_SERVICE_ACCOUNT_JSON) {
            const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_JSON);
            admin.initializeApp({
                credential: admin.credential.cert(serviceAccount),
            });
            logger_1.default.info('Firebase Admin SDK initialized successfully from environment variable');
        }
        else {
            const serviceAccountPath = path.resolve(__dirname, '../../firebase-service-account.json');
            if (fs.existsSync(serviceAccountPath)) {
                admin.initializeApp({
                    credential: admin.credential.cert(serviceAccountPath),
                });
                logger_1.default.info('Firebase Admin SDK initialized successfully from file');
            }
            else {
                logger_1.default.warn('Firebase Admin SDK not initialized: No config found');
            }
        }
    }
    catch (error) {
        logger_1.default.error('Failed to initialize Firebase Admin SDK', { error });
        // Don't throw, just log. If Firebase fails, auth middleware will catch it later.
    }
};
exports.initFirebase = initFirebase;
//# sourceMappingURL=firebase.js.map