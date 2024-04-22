const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const bcrypt = require("bcrypt")

const getAllUsers = async (req,res)=>{
    try {
        const users = await prisma.user.findMany();
        res.status(200).json(users)
    }catch(error){
        console.log('error in getAllUsers',error)
        res.status(500).send("error getting users")
    }
}

const postNewUser = async(req,res)=>{
    const {email,fName,lName,password} = req.body

    //Necessary verifications
    const existingUser = await prisma.user.findUnique({
        where: {
            email: email
        }
    })

    if (existingUser){
        return res.status(400).json({
            error: "This email is already used"
        })
    }else if(password.length < 4){
        return res.status(400).json({
            error : "password can't be less than 4 characters"
        })
    }

    //creating the new user
    const saltRounds = 10
    const hashedPassword = await bcrypt.hash(password,saltRounds)
    const newUser = {
        firstname: fName,
        lastname: lName,
        email: email,
        ispublic : true,
        hashed_password: hashedPassword
    }

    const createdUser = await prisma.user.create({
        data: newUser
    })

    res.status(201).json(createdUser)
}

const verifyExistingEmail= async(req,res)=>{
    const {email} = req.body

    //Necessary verifications
    const existingUser = await prisma.user.findUnique({
        where: {
            email: email
        }
    })

    if (existingUser){
        return res.status(400).json({
            error: "This email is already used"
        })
    }else{
        return res.status(200).json({
            message: "This email can be used"
        })
    }
}

module.exports = {getAllUsers,postNewUser,verifyExistingEmail}