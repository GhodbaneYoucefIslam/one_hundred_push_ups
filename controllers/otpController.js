const otpService = require("../services/otpService");
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

const otpSignUpSend = (req, res) => {
    const {email,fName,lName} = req.body;
    otpService.sendOtpSignUp(email,fName,lName, (error, result) => {
        if (error) {
            return res.status(400).send({
                message: "Error sending OTP",
                data: error
            });
        }
        return res.status(200).send({
            message: "OTP sent successfully",
            data: result
        });
    });
};

const otpChangePasswordSend = async (req, res) => {
    const {email} = req.body;

    const existingUser = await prisma.user.findUnique({
        where: {
            email: email
        }
    })

    if (!existingUser){
        return res.status(401).json({
            error: "No user associated with this email"
        })
    }
    otpService.sendOtpChangePassword(email,(error, result) => {
        if (error) {
            return res.status(400).send({
                message: "Error sending OTP",
                data: error
            });
        }
        return res.status(200).send({
            message: "OTP sent successfully",
            data: result
        });
    });
};

const otpSignUpVerify = (req, res) => {
    const {email,hash,otp} = req.body
    otpService.verifyOtp(email,hash,otp, (error, result) => {
        if (error) {
            return res.status(400).send({
                message: "Error verifying OTP",
                data: error
            });
        }
        return res.status(200).send({
            message: "OTP verification successful",
            data: result
        });
    });
};

module.exports = { otpSignUpSend, otpChangePasswordSend, otpSignUpVerify };
