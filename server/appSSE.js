const express = require('express');
const http = require('http');
const userRoutes = require('./routes/userNotifications');
const { socketAuthenticateToken } = require('./controller/authController');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const {messagesControl} = require("./controller/chats/userChat");
var cors = require('cors');
const { populateClientsMap } = require('./controller/notifications');
const userChat = require('./controller/chats/userChat')
const app = express();
var server = http.createServer(app);
var io = require('socket.io')(server, {
  cors: {
    origin: '*',
  },
});
app.use(cors());

app.use(express.static('images'));
app.use(express.static('cvs'));

app.use('/userNotifications', userRoutes);
populateClientsMap();


const socketUsernameMap = {};
io.on("connection", (socket) => {
  console.log("connected");
  console.log(socket.id);
  socket.on("/login", (msg) => {

    var status = socketAuthenticateToken(msg);
    if (status == 200) {
      const authHeader = msg
      const decoded = jwt.verify(authHeader, process.env.ACCESS_TOKEN_SECRET);
      var userUsername = decoded.username;
      console.log(userUsername);
      socketUsernameMap[userUsername] = socket;

      socket.emit("status", status);
    } else if (status == 403) {
      socket.emit("status", status);
    } else if (status == 409) {
      socket.emit("status", status);
    }
  });
  socket.on("/chat", async (msg) => {
    console.log(msg);
    const authHeader = msg.token;
    const decoded = jwt.verify(authHeader, process.env.ACCESS_TOKEN_SECRET);
    var userUsername = decoded.username;

    const username = msg.username;
    const targetSocket = socketUsernameMap[username];
    if (targetSocket) {
      targetSocket.emit("/chat", { message: msg.message, date:new Date() });
    } else {
      console.error('Socket not found for username:', username);
    }
    await messagesControl(userUsername,username,msg.message )
  });
  socket.on("disconnect", () => {
    const username = Object.keys(socketUsernameMap).find(
      (key) => socketUsernameMap[key] === socket
    );
    if (username) {
      delete socketUsernameMap[username];
    }
  });
})
server.listen(4000, () => {

  console.log('Server listening on port 4000');
});