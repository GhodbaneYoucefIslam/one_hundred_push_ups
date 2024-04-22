const nodemailer = require("nodemailer");

const sendEmail = async (email,subject,body,callback) => {
    // Create a Nodemailer transporter
    const transporter = nodemailer.createTransport({
        host: "smtp.gmail.com",
        port: 465,
        secure: true, // Use SSL
        auth: {
            user: "ghislamyoucef.dev@gmail.com",
            pass: "quxr gddm fjnr unub"
        }
    });

    // Define email options
    const mailOptions = {
        from: "ghislamyoucef.dev@gmail.com",
        to: email,
        subject: subject,
        text: body
    };

    // Send email
    transporter.sendMail(mailOptions,function(error,info){
        if(error){
            return callback(error)
        }else{
            return callback(null,info.response)
        }
    });
};

module.exports = { sendEmail };
