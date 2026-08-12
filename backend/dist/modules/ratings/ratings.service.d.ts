export declare class RatingsService {
    static submitRating(jobId: string, raterId: string, data: {
        value: 'THUMBS_UP' | 'THUMBS_DOWN';
        comment?: string;
    }): Promise<{
        id: string;
        createdAt: Date;
        value: string;
        jobId: string;
        raterId: string;
        ratedUserId: string;
        comment: string | null;
    }>;
}
//# sourceMappingURL=ratings.service.d.ts.map