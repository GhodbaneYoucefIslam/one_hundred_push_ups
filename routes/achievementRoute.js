const express = require("express")
const router = express.Router()
const achievementController = require('../controllers/achievementController')

router.get('/:day/:type',achievementController.getAchievementsByDateAndType)
router.get('/user/:userId/:type',achievementController.getUserAchievements)
router.post('/',achievementController.postAchievement)

module.exports = router