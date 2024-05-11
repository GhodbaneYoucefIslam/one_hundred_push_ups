const express = require("express")
const router = express.Router()
const userController = require('../controllers/userController')
const otpController = require("../controllers/otpController")

router.get("/",userController.getAllUsers)
router.post("/otp/send/signUp",otpController.otpSignUpSend)
router.post("/otp/send/forgotPassword",otpController.otpChangePasswordSend)
router.post("/otp/verify",otpController.otpSignUpVerify)
router.post("/create",userController.postNewUser)
router.post("/changePassword",userController.changeUserPassword)
router.post("/verifyEmail",userController.verifyExistingEmail)
router.post("/login",userController.login)

module.exports = router
