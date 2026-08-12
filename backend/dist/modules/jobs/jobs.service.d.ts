export declare class JobsService {
    static createJob(householdId: string, data: {
        title: string;
        description: string;
        category: string;
        jobDate: string;
        jobTime?: string;
        latitude: number;
        longitude: number;
        address?: string;
        budgetAmount: number;
        budgetType?: 'FIXED' | 'NEGOTIABLE';
    }): Promise<{
        household: {
            id: string;
            name: string | null;
            photoUrl: string | null;
        };
    } & {
        id: string;
        latitude: number;
        longitude: number;
        cityId: string | null;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        address: string | null;
        status: string;
        title: string;
        description: string;
        category: string;
        jobDate: Date;
        jobTime: string | null;
        budgetAmount: number;
        budgetType: string;
        householdId: string;
        assignedWorkerId: string | null;
    }>;
    static listJobs(filters: {
        latitude?: number;
        longitude?: number;
        radius?: number;
        category?: string;
        status?: string;
        page?: number;
        limit?: number;
    }): Promise<{
        jobs: {
            id: string;
            title: string;
            description: string;
            category: string;
            jobDate: Date;
            jobTime: string | null;
            address: string | null;
            latitude: number;
            longitude: number;
            budgetAmount: number;
            budgetType: string;
            status: string;
            createdAt: Date;
            household: {
                id: string;
                name: string | null;
                photoUrl: string | null;
            };
            distance: number;
        }[];
        meta: {
            page: number;
            limit: number;
            total: number;
        };
    }>;
    static getJobById(jobId: string): Promise<{
        _count: {
            interests: number;
            ratings: number;
        };
        household: {
            id: string;
            name: string | null;
            photoUrl: string | null;
            householdProfile: {
                id: string;
                createdAt: Date;
                updatedAt: Date;
                userId: string;
                thumbsUp: number;
                thumbsDown: number;
                address: string | null;
            } | null;
        };
        assignedWorker: {
            id: string;
            name: string | null;
            photoUrl: string | null;
            workerProfile: {
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
            } | null;
        } | null;
    } & {
        id: string;
        latitude: number;
        longitude: number;
        cityId: string | null;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        address: string | null;
        status: string;
        title: string;
        description: string;
        category: string;
        jobDate: Date;
        jobTime: string | null;
        budgetAmount: number;
        budgetType: string;
        householdId: string;
        assignedWorkerId: string | null;
    }>;
    static cancelJob(jobId: string, userId: string): Promise<{
        id: string;
        latitude: number;
        longitude: number;
        cityId: string | null;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        address: string | null;
        status: string;
        title: string;
        description: string;
        category: string;
        jobDate: Date;
        jobTime: string | null;
        budgetAmount: number;
        budgetType: string;
        householdId: string;
        assignedWorkerId: string | null;
    }>;
    static getMyPosts(userId: string): Promise<({
        _count: {
            interests: number;
        };
        assignedWorker: {
            id: string;
            name: string | null;
            photoUrl: string | null;
        } | null;
    } & {
        id: string;
        latitude: number;
        longitude: number;
        cityId: string | null;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        address: string | null;
        status: string;
        title: string;
        description: string;
        category: string;
        jobDate: Date;
        jobTime: string | null;
        budgetAmount: number;
        budgetType: string;
        householdId: string;
        assignedWorkerId: string | null;
    })[]>;
    static updateJobStatus(jobId: string, userId: string, status: string): Promise<{
        id: string;
        latitude: number;
        longitude: number;
        cityId: string | null;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        address: string | null;
        status: string;
        title: string;
        description: string;
        category: string;
        jobDate: Date;
        jobTime: string | null;
        budgetAmount: number;
        budgetType: string;
        householdId: string;
        assignedWorkerId: string | null;
    }>;
    static applyForJob(jobId: string, workerId: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        status: string;
        jobId: string;
        workerId: string;
    }>;
    static getApplicants(jobId: string, householdId: string): Promise<({
        worker: {
            id: string;
            phone: string;
            name: string | null;
            photoUrl: string | null;
            workerProfile: {
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
            } | null;
        };
    } & {
        id: string;
        createdAt: Date;
        updatedAt: Date;
        status: string;
        jobId: string;
        workerId: string;
    })[]>;
    static assignWorker(jobId: string, householdId: string, workerId: string): Promise<{
        household: {
            name: string | null;
        };
    } & {
        id: string;
        latitude: number;
        longitude: number;
        cityId: string | null;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        address: string | null;
        status: string;
        title: string;
        description: string;
        category: string;
        jobDate: Date;
        jobTime: string | null;
        budgetAmount: number;
        budgetType: string;
        householdId: string;
        assignedWorkerId: string | null;
    }>;
}
//# sourceMappingURL=jobs.service.d.ts.map