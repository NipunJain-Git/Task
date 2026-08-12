const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log("Connecting to database...");
  try {
    const count = await prisma.user.count();
    console.log("SUCCESS! User count:", count);
  } catch (e) {
    console.error("DB ERROR:", e.message);
  } finally {
    await prisma.$disconnect();
  }
}
main();
