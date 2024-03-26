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
                type: type,
                user: {
                    ispublic: true // Filter users where ispublic is true
                }
            },
            select : {
                score: true,
                day: true,
                dailyRank: true,
                rankChange: true,
                user: {
                    select:{
                        id: true,
                        firstname: true,
                        lastname: true,
                        email: true,
                        hashed_password: false
                    }
                }
            },
            orderBy: [
                {
                    score: "desc"
                }
            ]
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
        //update the ranks 
        await updateAchievementRanks(day,type);
    } catch (error) {
        console.error("Error in postAchievement: ", error);
        res.status(500).json({ error: "An error occurred while adding the achievement" });
    }
};

const updateAchievementRanks = async (day, type) => {
    try {
        // Execute the SQL query to update achievement ranks
        await prisma.$executeRaw`UPDATE achievement AS a
        JOIN (
            SELECT id, RANK() OVER (ORDER BY score DESC) AS new_dailyRank
            FROM achievement
            WHERE day = CAST(${day.toString()} AS DATE) AND type = ${type.toString()}
        ) AS b ON a.id = b.id
        SET a.dailyRank = b.new_dailyRank;`;

        console.log("Achievement ranks updated successfully.");
    } catch (error) {
        console.error("Error updating achievement ranks:", error);
    }
};







module.exports = { getAchievementsByDateAndType,postAchievement,updateAchievementRanks };
