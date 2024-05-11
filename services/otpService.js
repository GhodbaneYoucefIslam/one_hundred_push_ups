const otpGenerator = require("otp-generator");
const emailerService = require("./emailerService");
const crypto = require('crypto');

const key = "1234";

const sendOtpSignUp = async (email,fName,lName,callback) => {
        // Generate OTP
        const otp = otpGenerator.generate(4, {
            digits: true,
            lowerCaseAlphabets: false,
            upperCaseAlphabets: false,
            specialChars: false
        });

        // Calculate hash and expiration time
        const ttl = 60 * 1000; // 5 min
        const expires = Date.now() + ttl;
        const data = `${email}.${otp}.${expires}`;
        const hash = crypto.createHmac("sha256", key).update(data).digest("hex");
        const fullHash = `${hash}.${expires}`;

        // Prepare email message
        const message = `Dear ${fName} ${lName},\n\nWelcome to 100PushUPs! Use the code: ${otp} to verify your registration. Please note that this code is only valid for the next 5 minutes.\n\nBest regards, the dev team`;
        const emailParams = {
            email: email,
            subject: "[100PushUps] Registration",
            body: message
        };

        // Send email
        emailerService.sendEmail(emailParams.email,emailParams.subject,emailParams.body, (error, result) => {
            if (error) {
                return callback(error);
            }
            return callback(null, fullHash);
        });
}

const sendOtpChangePassword = async (email,callback) => {
    // Generate OTP
    const otp = otpGenerator.generate(4, {
        digits: true,
        lowerCaseAlphabets: false,
        upperCaseAlphabets: false,
        specialChars: false
    });

    // Calculate hash and expiration time
    const ttl = 5 *60 * 1000; // 5 min
    const expires = Date.now() + ttl;
    const data = `${email}.${otp}.${expires}`;
    const hash = crypto.createHmac("sha256", key).update(data).digest("hex");
    const fullHash = `${hash}.${expires}`;

    // Prepare email message
    const message = `Dear user,\n\nUse the code: ${otp} to change your password. Please note that this code is only valid for the next 5 minutes.\n\nIf you were not at the origin of this request you can safely ignore this email.\n\nBest regards, the dev team`;
    const emailParams = {
        email: email,
        subject: "[100PushUps] Change password",
        body: message
    };

    // Send email
    emailerService.sendEmail(emailParams.email,emailParams.subject,emailParams.body, (error, result) => {
        if (error) {
            return callback(error);
        }
        return callback(null, fullHash);
    });
}


const verifyOtp = async (email,hash,otp,callback) => {
    const [hashValue, expires] = hash.split('.');
    const now = Date.now();
    
    if (now > parseInt(expires)) {
        return callback("Code expired");
    }

    const data = `${email}.${otp}.${expires}`;
    const newCalculatedHash = crypto.createHmac("sha256", key).update(data).digest("hex");

    if (newCalculatedHash === hashValue) {
        return callback(null, "Verification successful!");
    }
    
    return callback("Invalid verification code");
};

module.exports = {sendOtpSignUp, sendOtpChangePassword, verifyOtp };
