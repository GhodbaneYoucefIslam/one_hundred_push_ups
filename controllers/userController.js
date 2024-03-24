const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

const getAllUsers = async (req,res)=>{
    try {
        const users = await prisma.user.findMany();
        res.status(200).json(users)
    }catch(error){
        console.log('error in getAllUsers',error)
        res.status(500).send("error getting users")
    }
}

module.exports = {getAllUsers}