import { z } from 'zod';
export declare const updateProfileSchema: z.ZodObject<{
    name: z.ZodOptional<z.ZodString>;
    language: z.ZodOptional<z.ZodEnum<["en", "hi"]>>;
    latitude: z.ZodOptional<z.ZodNumber>;
    longitude: z.ZodOptional<z.ZodNumber>;
}, "strip", z.ZodTypeAny, {
    name?: string | undefined;
    language?: "en" | "hi" | undefined;
    latitude?: number | undefined;
    longitude?: number | undefined;
}, {
    name?: string | undefined;
    language?: "en" | "hi" | undefined;
    latitude?: number | undefined;
    longitude?: number | undefined;
}>;
export declare const updateWorkerProfileSchema: z.ZodObject<{
    skills: z.ZodOptional<z.ZodArray<z.ZodString, "many">>;
    expectedWage: z.ZodOptional<z.ZodNumber>;
    wageType: z.ZodOptional<z.ZodEnum<["DAILY", "HOURLY"]>>;
    workRadius: z.ZodOptional<z.ZodNumber>;
}, "strip", z.ZodTypeAny, {
    skills?: string[] | undefined;
    expectedWage?: number | undefined;
    wageType?: "DAILY" | "HOURLY" | undefined;
    workRadius?: number | undefined;
}, {
    skills?: string[] | undefined;
    expectedWage?: number | undefined;
    wageType?: "DAILY" | "HOURLY" | undefined;
    workRadius?: number | undefined;
}>;
export declare const updateHouseholdProfileSchema: z.ZodObject<{
    address: z.ZodOptional<z.ZodString>;
}, "strip", z.ZodTypeAny, {
    address?: string | undefined;
}, {
    address?: string | undefined;
}>;
export declare const toggleAvailabilitySchema: z.ZodObject<{
    isAvailable: z.ZodBoolean;
}, "strip", z.ZodTypeAny, {
    isAvailable: boolean;
}, {
    isAvailable: boolean;
}>;
//# sourceMappingURL=users.validators.d.ts.map