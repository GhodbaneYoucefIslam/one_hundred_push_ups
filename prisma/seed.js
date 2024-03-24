const { PrismaClient } = require("@prisma/client");
const users = require("./users")
const achievements = require("./achievements")

const prisma = new PrismaClient

async function main(){
    try {
        await prisma.achievement.deleteMany()
        await prisma.$queryRaw`ALTER SEQUENCE achievement_id_seq restart with 1`
        await prisma.user.deleteMany()
        await prisma.$queryRaw`ALTER SEQUENCE user_id_seq restart with 1`

        await prisma.user.createMany({
            data : users
        })
        await prisma.achievement.createMany({
            data: achievements
        })
    }catch (error) {
        console.log("Error in seeding:", error);
    } finally {
        await prisma.$disconnect();
    }
}

main()