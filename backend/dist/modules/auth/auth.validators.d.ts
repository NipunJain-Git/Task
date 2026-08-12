import { z } from 'zod';
export declare const sendOtpSchema: z.ZodObject<{
    phone: z.ZodString;
}, "strip", z.ZodTypeAny, {
    phone: string;
}, {
    phone: string;
}>;
export declare const verifyOtpSchema: z.ZodObject<{
    phone: z.ZodString;
    otp: z.ZodString;
    sessionId: z.ZodOptional<z.ZodString>;
    role: z.ZodOptional<z.ZodString>;
}, "strip", z.ZodTypeAny, {
    phone: string;
    otp: string;
    role?: string | undefined;
    sessionId?: string | undefined;
}, {
    phone: string;
    otp: string;
    role?: string | undefined;
    sessionId?: string | undefined;
}>;
export declare const selectRoleSchema: z.ZodObject<{
    role: z.ZodEnum<["WORKER", "HOUSEHOLD"]>;
    familyMemberContact: z.ZodOptional<z.ZodString>;
    familyMemberRelation: z.ZodOptional<z.ZodString>;
}, "strip", z.ZodTypeAny, {
    role: "HOUSEHOLD" | "WORKER";
    familyMemberContact?: string | undefined;
    familyMemberRelation?: string | undefined;
}, {
    role: "HOUSEHOLD" | "WORKER";
    familyMemberContact?: string | undefined;
    familyMemberRelation?: string | undefined;
}>;
//# sourceMappingURL=auth.validators.d.ts.map