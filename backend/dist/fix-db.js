"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function main() {
    const users = await prisma.user.findMany({
        orderBy: { createdAt: 'desc' },
        take: 10
    });
    console.log('Recent Users:');
    for (const user of users) {
        console.log(`- ${user.phone}: ${user.role}`);
        // Fix null or lowercase roles
        if (!user.role || user.role === 'household' || user.role === 'worker') {
            const fixedRole = user.role ? user.role.toUpperCase() : 'HOUSEHOLD';
            await prisma.user.update({
                where: { id: user.id },
                data: { role: fixedRole }
            });
            console.log(`  -> Fixed ${user.phone} to ${fixedRole}`);
        }
    }
}
main().catch(console.error).finally(() => prisma.$disconnect());
//# sourceMappingURL=fix-db.js.map