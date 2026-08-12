import { z } from 'zod';
export declare const setupPinSchema: z.ZodObject<{
    pin: z.ZodString;
}, "strip", z.ZodTypeAny, {
    pin: string;
}, {
    pin: string;
}>;
export declare const addMoneySchema: z.ZodObject<{
    amount: z.ZodNumber;
    referenceId: z.ZodOptional<z.ZodString>;
}, "strip", z.ZodTypeAny, {
    amount: number;
    referenceId?: string | undefined;
}, {
    amount: number;
    referenceId?: string | undefined;
}>;
export declare const transferToFamilySchema: z.ZodObject<{
    amount: z.ZodNumber;
    pin: z.ZodString;
}, "strip", z.ZodTypeAny, {
    amount: number;
    pin: string;
}, {
    amount: number;
    pin: string;
}>;
export declare const jobPayoutSchema: z.ZodObject<{
    jobId: z.ZodString;
    amount: z.ZodNumber;
    pin: z.ZodString;
}, "strip", z.ZodTypeAny, {
    jobId: string;
    amount: number;
    pin: string;
}, {
    jobId: string;
    amount: number;
    pin: string;
}>;
//# sourceMappingURL=wallet.validators.d.ts.map