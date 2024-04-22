const otpService = require("../services/otpService");

const otpSignUpSend = (req, res) => {
    const {email,fName,lName} = req.body;
    otpService.sendOtp(email,fName,lName, (error, result) => {
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

module.exports = { otpSignUpSend, otpSignUpVerify };
