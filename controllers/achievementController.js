const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient(); // Fix variable name

const getAchievementsByDateAndType = async (req, res) => {
    try {
        const day = req.params.day;
        const type = req.params.type;
        
        // Use `prisma` instead of `Prisma`
        const achievements = await prisma.achievement.findMany({
            where: {
                day: day,
                type: type
            }
        });

        res.status(200).json(achievements);
    } catch (error) {
        console.log("error in getAchievementsByDateAndType", error);
        res.status(500).send("error");
    }
}

const postAchievement = async (req, res) => {
    const { type, score, day, userId } = req.body;

    // Validate request body
    if (!type || !score || !day || !userId) {
        return res.status(400).json({ error: "Missing required fields in request body" });
    }

    try {
        // Check if achievement already exists for the day and userId
        const existingAchievement = await prisma.achievement.findFirst({
            where: {
                day: day,
                userId: userId
            }
        });

        if (existingAchievement) {
            return res.status(400).json({ error: "An achievement for this day and user already exists" });
        }
        console.log(req)
        // Create new achievement
        const insertedAchievement = await prisma.achievement.create({
            data: {
              type: req.body.type,
              score: req.body.score,
              day: req.body.day,
              userId: req.body.userId
            }
          });

        res.status(201).json(insertedAchievement);
        console.log("Achievement added successfully: ", insertedAchievement);
    } catch (error) {
        console.error("Error in postAchievement: ", error);
        res.status(500).json({ error: "An error occurred while adding the achievement" });
    }
};


module.exports = { getAchievementsByDateAndType,postAchievement };
