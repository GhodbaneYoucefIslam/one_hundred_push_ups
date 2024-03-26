const { PrismaClient } = require("@prisma/client")
const users = require("./users")
const achievements = require("./achievements")
const achievementController = require('../controllers/achievementController')

const prisma = new PrismaClient

async function main(){
    try {
        await prisma.achievement.deleteMany()
        await prisma.$queryRaw`ALTER TABLE achievement AUTO_INCREMENT = 1`
        await prisma.user.deleteMany()
        await prisma.$queryRaw`ALTER TABLE user AUTO_INCREMENT = 1`

        await prisma.user.createMany({
            data : users
        })
        await prisma.achievement.createMany({
            data: achievements
        })
        day = '2024-03-25T00:00:00Z'
        type= 'pushups'
        await achievementController.updateAchievementRanks(day,type)
    }catch (error) {
        console.log("Error in seeding:", error);
    } finally {
        await prisma.$disconnect();
        console.log("seeding successful")
    }
}

main()