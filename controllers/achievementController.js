const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

const getAchievementsByDateAndType = async (req, res) => {
    try {
        const day = req.params.day;
        const type = req.params.type;
        
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

    try {
        // Validate request body
        if (!type || !score || !day || !userId) {
            return res.status(400).json({ error: "Missing required fields in request body" });
        }

        let insertedAchievement;
        let achievementUpdated = false;

        // Check if achievement already exists for the day and userId
        const existingAchievement = await prisma.achievement.findFirst({
            where: {
                type: type,
                day: day,
                userId: userId
            }
        });

        if (existingAchievement) {
            console.log("there is an existing achievement for this user in this type and day")
            if (existingAchievement.score !== score) {
                // Update the existing achievement's score
                const updatedAchievement = await prisma.achievement.update({
                    where: {
                        id: existingAchievement.id
                    },
                    data: {
                        score: score
                    }
                });
                achievementUpdated = true;
                res.status(200).json(updatedAchievement);
                console.log("Achievement score updated successfully:", updatedAchievement);
            } else {
                res.status(400).json({ remark: "Nothing to update" });
            }
        } else {
            // Create new achievement
            insertedAchievement = await prisma.achievement.create({
                data: {
                    type: type,
                    score: score,
                    day: day,
                    userId: userId
                }
            });
            res.status(201).json(insertedAchievement);
            console.log("Achievement added successfully:", insertedAchievement);
        }

        // Update the ranks if a new achievement is added or an existing one is updated
        if (achievementUpdated || insertedAchievement) {
            await updateAchievementRanks(day, type);
            console.log("Achievement ranks updated successfully.");
            await updateAchievementRankChange(day, type);
            console.log("updated rank changes successfully")
        }
    } catch (error) {
        console.error("Error in postAchievement:", error);
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

const getUserAchievements = async (req,res) =>{
    try{
        const userId = parseInt(req.params.userId)
        const type = req.params.type
        const achievements = await prisma.achievement.findMany({
            where:{
                userId : userId,
                type : type
            },
            orderBy:[{
                day: "asc"
            }]
        })
        res.status(200).json(achievements)
        console.log("request sucessfull")
    }catch(error){
        console.log("error getting user achievements:",error)
        res.status(500).send("error")
    }
}

const updateAchievementRankChange = async (day, type) => {
    try {
        // Get today's achievements
        const todayAchievements = await prisma.achievement.findMany({
            where: {
                day: day,
                type: type,
                user: {
                    ispublic: true // Filter users where ispublic is true
                }
            },
            select: {
                id: true,
                score: true,
                day: true,
                dailyRank: true,
                rankChange: true,
                user: {
                    select: {
                        id: true,
                        firstname: true,
                        lastname: true,
                        email: true
                    }
                }
            },
            orderBy: [
                {
                    score: "desc"
                }
            ]
        });

        // Update rank change for each user
        await Promise.all(todayAchievements.map(async (achievement) => {
            try {
                // Get the previous achievements for the user
                const previousAchievements = await prisma.achievement.findMany({
                    where: {
                        userId: achievement.user.id,
                        type: type,
                        day: { lt: day }
                    },
                    orderBy: [{
                        day: "desc"
                    }],
                    take: 1 // Only get the most recent previous achievement
                });

                if (previousAchievements.length > 0) {
                    const previousUserAchievement = previousAchievements[0];
                    const rankChange = previousUserAchievement.dailyRank - achievement.dailyRank;
                    
                    // Only update if rankChange has actually changed
                    if (rankChange !== achievement.rankChange) {
                        const updatedAchievement = await prisma.achievement.update({
                            where: {
                                id: achievement.id
                            },
                            data: {
                                rankChange: rankChange
                            }
                        });

                        console.log("Updated achievement rank change successfully", updatedAchievement);
                    }
                }
            } catch (innerError) {
                console.log(`Error updating rank change for achievement ID ${achievement.id}`, innerError);
            }
        }));
    } catch (error) {
        console.log("Error in updateRankChanges", error);
    }
};


module.exports = { updateAchievementRankChange };





module.exports = { getAchievementsByDateAndType,postAchievement,updateAchievementRanks,getUserAchievements };
