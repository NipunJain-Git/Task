export declare class AuthService {
    static sendOtp(phone: string): Promise<{
        message: string;
        sessionId?: string;
    }>;
    static verifyOtp(phone: string, otp: string, sessionId?: string): Promise<{
        accessToken: string;
        refreshToken: string;
        user: {
            id: string;
            phone: string;
            role: string | null;
            name: string | null;
            isNewUser: boolean;
            onboarded: boolean;
        };
    }>;
    static refreshToken(token: string): Promise<{
        accessToken: string;
        refreshToken: string;
    }>;
    static verifyFirebase(idToken: string, role?: string): Promise<{
        accessToken: string;
        refreshToken: string;
        user: {
            id: string;
            phone: string;
            role: string | null;
            name: string | null;
            isNewUser: boolean;
            onboarded: boolean;
        };
    }>;
    static selectRole(userId: string, role: 'WORKER' | 'HOUSEHOLD', familyMemberContact?: string, familyMemberRelation?: string): Promise<unknown>;
}
//# sourceMappingURL=auth.service.d.ts.map