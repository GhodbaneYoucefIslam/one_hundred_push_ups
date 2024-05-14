const express = require('express')
const userRoute = require("./routes/userRoute")
const achievementRoute = require("./routes/achievementRoute")
const bodyParser = require("body-parser")
const normmalizePort = require('normalize-port')
const port = normmalizePort(process.env.PORT || '3000')
const app = express()
const http = require('http')
app.use(express.json())

/*app.set('port',port)
const server = http.createServer(app)
server.listen(process.env.PORT,process.env.IP, ()=>{
    console.log("server listening on port ", port)
})*/

app.listen(port, ()=>{
    console.log("server listening on port ", port)
})

app.get('/',async (req,res)=>{
    res.send("Hello world!")
})

app.use('/user', userRoute)
app.use('/achievement',achievementRoute)
