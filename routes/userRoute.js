const express = require("express")
const router = express.Router()
const userController = require('../controllers/userController')
const otpController = require("../controllers/otpController")

router.get("/",userController.getAllUsers)
router.post("/otp/send",otpController.otpSignUpSend)
router.post("/otp/verify",otpController.otpSignUpVerify)
router.post("/create",userController.postNewUser)
router.post("/verifyEmail",userController.verifyExistingEmail)

module.exports = router
