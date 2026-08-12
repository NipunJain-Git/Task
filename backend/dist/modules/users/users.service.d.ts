export declare class UsersService {
    static getMe(userId: string): Promise<Record<string, unknown>>;
    static updateProfile(userId: string, data: {
        name?: string;
        language?: string;
        latitude?: number;
        longitude?: number;
    }): Promise<{
        id: string;
        phone: string;
        role: string | null;
        name: string | null;
        photoUrl: string | null;
        language: string;
        latitude: number | null;
        longitude: number | null;
        familyMemberContact: string | null;
        familyMemberRelation: string | null;
        walletPin: string | null;
        fcmToken: string | null;
        cityId: string | null;
        kycStatus: string;
        kycDocumentUrl: string | null;
        identityNumber: string | null;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
    }>;
    static updateWorkerProfile(userId: string, data: {
        skills?: string[];
        expectedWage?: number;
        wageType?: 'DAILY' | 'HOURLY';
        workRadius?: number;
    }): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        skills: string;
        expectedWage: number | null;
        wageType: string;
        isAvailable: boolean;
        workRadius: number;
        thumbsUp: number;
        thumbsDown: number;
        videoProfileUrl: string | null;
        portfolioUrls: string;
    }>;
    static updateHouseholdProfile(userId: string, data: {
        address?: string;
    }): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        thumbsUp: number;
        thumbsDown: number;
        address: string | null;
    }>;
    static toggleAvailability(userId: string, isAvailable: boolean): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        skills: string;
        expectedWage: number | null;
        wageType: string;
        isAvailable: boolean;
        workRadius: number;
        thumbsUp: number;
        thumbsDown: number;
        videoProfileUrl: string | null;
        portfolioUrls: string;
    }>;
    static getUserById(id: string): Promise<Record<string, unknown>>;
    static getRatingSummary(userId: string): Promise<{
        thumbsUp: number;
        thumbsDown: number;
        total: number;
        positivePercent: number;
        recentRatings: ({
            rater: {
                name: string | null;
                photoUrl: string | null;
            };
        } & {
            id: string;
            createdAt: Date;
            value: string;
            jobId: string;
            raterId: string;
            ratedUserId: string;
            comment: string | null;
        })[];
    }>;
}
//# sourceMappingURL=users.service.d.ts.map