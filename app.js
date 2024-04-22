const express = require('express')
const userRoute = require("./routes/userRoute")
const achievementRoute = require("./routes/achievementRoute")
const bodyParser = require("body-parser")
const port = 3000
const app = express()
app.use(express.json())
app.listen(port, ()=>{
    console.log("server listening on port ", port)
})

app.get('/',async (req,res)=>{
    res.send("Hello world!")
})

app.use('/user', userRoute)
app.use('/achievement',achievementRoute)
