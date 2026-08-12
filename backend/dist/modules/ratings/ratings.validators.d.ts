import { z } from 'zod';
export declare const submitRatingSchema: z.ZodObject<{
    value: z.ZodEnum<["THUMBS_UP", "THUMBS_DOWN"]>;
    comment: z.ZodOptional<z.ZodString>;
}, "strip", z.ZodTypeAny, {
    value: "THUMBS_UP" | "THUMBS_DOWN";
    comment?: string | undefined;
}, {
    value: "THUMBS_UP" | "THUMBS_DOWN";
    comment?: string | undefined;
}>;
//# sourceMappingURL=ratings.validators.d.ts.map