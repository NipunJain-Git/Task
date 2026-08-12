export declare class InterestsService {
    static expressInterest(jobId: string, workerId: string): Promise<{
        worker: {
            id: string;
            name: string | null;
            photoUrl: string | null;
        };
    } & {
        id: string;
        createdAt: Date;
        updatedAt: Date;
        status: string;
        jobId: string;
        workerId: string;
    }>;
    static listInterestedWorkers(jobId: string, userId: string): Promise<{
        worker: {
            workerProfile: {
                skills: any;
                id: string;
                createdAt: Date;
                updatedAt: Date;
                userId: string;
                expectedWage: number | null;
                wageType: string;
                isAvailable: boolean;
                workRadius: number;
                thumbsUp: number;
                thumbsDown: number;
                videoProfileUrl: string | null;
                portfolioUrls: string;
            } | null;
            id: string;
            name: string | null;
            photoUrl: string | null;
        };
        id: string;
        createdAt: Date;
        updatedAt: Date;
        status: string;
        jobId: string;
        workerId: string;
    }[]>;
    static acceptOrReject(jobId: string, interestId: string, userId: string, action: 'ACCEPTED' | 'REJECTED'): Promise<{
        success: boolean;
    }>;
    static getMyInterests(workerId: string): Promise<({
        job: {
            id: string;
            household: {
                id: string;
                name: string | null;
                photoUrl: string | null;
            };
            address: string | null;
            status: string;
            title: string;
            category: string;
            jobDate: Date;
            budgetAmount: number;
            budgetType: string;
        };
    } & {
        id: string;
        createdAt: Date;
        updatedAt: Date;
        status: string;
        jobId: string;
        workerId: string;
    })[]>;
}
//# sourceMappingURL=interests.service.d.ts.map