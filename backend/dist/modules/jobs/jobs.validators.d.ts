import { z } from 'zod';
export declare const createJobSchema: z.ZodObject<{
    title: z.ZodString;
    description: z.ZodString;
    category: z.ZodString;
    jobDate: z.ZodEffects<z.ZodString, string, string>;
    jobTime: z.ZodOptional<z.ZodString>;
    latitude: z.ZodNumber;
    longitude: z.ZodNumber;
    address: z.ZodOptional<z.ZodString>;
    budgetAmount: z.ZodNumber;
    budgetType: z.ZodDefault<z.ZodEnum<["FIXED", "NEGOTIABLE"]>>;
}, "strip", z.ZodTypeAny, {
    latitude: number;
    longitude: number;
    title: string;
    description: string;
    category: string;
    jobDate: string;
    budgetAmount: number;
    budgetType: "FIXED" | "NEGOTIABLE";
    address?: string | undefined;
    jobTime?: string | undefined;
}, {
    latitude: number;
    longitude: number;
    title: string;
    description: string;
    category: string;
    jobDate: string;
    budgetAmount: number;
    address?: string | undefined;
    jobTime?: string | undefined;
    budgetType?: "FIXED" | "NEGOTIABLE" | undefined;
}>;
export declare const jobFiltersSchema: z.ZodObject<{
    latitude: z.ZodOptional<z.ZodNumber>;
    longitude: z.ZodOptional<z.ZodNumber>;
    radius: z.ZodDefault<z.ZodNumber>;
    category: z.ZodOptional<z.ZodString>;
    status: z.ZodDefault<z.ZodString>;
    page: z.ZodDefault<z.ZodNumber>;
    limit: z.ZodDefault<z.ZodNumber>;
}, "strip", z.ZodTypeAny, {
    status: string;
    radius: number;
    page: number;
    limit: number;
    latitude?: number | undefined;
    longitude?: number | undefined;
    category?: string | undefined;
}, {
    latitude?: number | undefined;
    longitude?: number | undefined;
    status?: string | undefined;
    category?: string | undefined;
    radius?: number | undefined;
    page?: number | undefined;
    limit?: number | undefined;
}>;
export declare const updateJobStatusSchema: z.ZodObject<{
    status: z.ZodEnum<["ASSIGNED", "IN_PROGRESS", "COMPLETED", "CANCELLED"]>;
}, "strip", z.ZodTypeAny, {
    status: "ASSIGNED" | "CANCELLED" | "IN_PROGRESS" | "COMPLETED";
}, {
    status: "ASSIGNED" | "CANCELLED" | "IN_PROGRESS" | "COMPLETED";
}>;
//# sourceMappingURL=jobs.validators.d.ts.map