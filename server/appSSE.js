const express = require('express');
const http = require('http');
const userRoutes = require('./routes/userNotifications');
const { socketAuthenticateToken } = require('./controller/authController');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const { messagesControl, messageSaveImage, messageSaveVideo } = require("./controller/chats/userChat");
var cors = require('cors');
const { populateClientsMap } = require('./controller/notifications');
const userChat = require('./controller/chats/userChat')
const app = express();
var server = http.createServer(app);
var io = require('socket.io')(server, {
  cors: {
    origin: '*',
  },
  maxHttpBufferSize: 1e8,
});
app.use(cors());

app.use(express.static('messageVideos'));

app.use(express.static('messageImages'));
app.use(express.static('images'));
app.use(express.static('cvs'));

app.use('/userNotifications', userRoutes);
populateClientsMap();


const socketUsernameMap = {};
io.on("connection", (socket) => {// first time socket connection
  console.log("connected");
  console.log(socket.id);
  socket.on("/login", (msg) => {//socketAuthenticate logain and save the user socket and map it to his username

    var status = socketAuthenticateToken(msg);// check token
    console.log(status)
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
  socket.on("/chat", async (msg) => {//when a new message arrive 
    console.log(msg);
    const authHeader = msg.token;
    var status = socketAuthenticateToken(msg.token);// check token
    if (status == 200) {//authenticated
      console.log(msg.message);
      console.log(msg.messageVideoBytes);//messageVideoBytes
      if (msg.message != null || msg.messageImageBytes != null || msg.messageVideoBytes != null) {
        const decoded = jwt.verify(authHeader, process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        var messageImageName;
        var messageVideoName;
        const username = msg.username;
        const targetSocket = socketUsernameMap[username];//find receiver
        //if theres image save it
        if (msg.messageImageBytes != null && msg.messageImageBytesName != null && msg.messageImageExt != null)
          messageImageName = await messageSaveImage(userUsername, username, msg.messageImageBytes, msg.messageImageBytesName, msg.messageImageExt)

        if (msg.messageVideoBytes != null && msg.messageVideoBytesName != null && msg.messageVideoExt != null) {
          messageVideoName = await messageSaveVideo(userUsername, username, msg.messageVideoBytes, msg.messageVideoBytesName, msg.messageVideoExt)
          var userSocket = socketUsernameMap[userUsername];
          if (userSocket)
            userSocket.emit("/chatMyVideo", { message: msg.message, image: messageImageName, video: messageVideoName });
        }
        //if target user is in message page send it via his socket
        if (targetSocket) {
          targetSocket.emit("/chat", { message: msg.message, image: messageImageName, video: messageVideoName, date: new Date() });
        } else {// just for showing result when user not in message page
          console.log('Socket not found for username:', username);
        }
        //save the message in db after sending it via socket
        await messagesControl(userUsername, username, msg.message, messageImageName, messageVideoName)
      }
    } else if (status == 403) {//not authenticated to send messages using this token
      socket.emit("/chatStatus", {
        "status": status,
        "message": msg.message,
        "username": msg.username,
        "messageImageBytes": msg.messageImageBytes,
        "messageImageBytesName": msg.messageImageBytesName,
        "messageImageExt": msg.messageImageExt,
      });
    } else if (status == 409) {//not authenticated to send messages using this token
      socket.emit("/chatStatus", {
        "status": status,
        "message": msg.message,
        "username": msg.username,
        "username": msg.username,
        "messageImageBytes": msg.messageImageBytes,
        "messageImageBytesName": msg.messageImageBytesName,
        "messageImageExt": msg.messageImageExt,
      });
    }

  });
  socket.on("makeCall", (data) => {
    let calleeId = data.calleeId;
    let sdpOffer = data.sdpOffer;
      var userUsername = data.callerId;
      const targetSocket = socketUsernameMap[calleeId];
      if (targetSocket) {
        targetSocket.emit("newCall", {
          callerId: userUsername,
          sdpOffer: sdpOffer,
        });
    }
  });

  socket.on("answerCall", (data) => {
    let callerId = data.callerId;
    let sdpAnswer = data.sdpAnswer;
      var userUsername = data.calleeId;

      const targetSocket = socketUsernameMap[callerId];
      if (targetSocket) {
        targetSocket.emit("callAnswered", {
          callee: userUsername,
          sdpAnswer: sdpAnswer,
        });
      }
    
  });

  socket.on("IceCandidate", (data) => {
    let calleeId = data.calleeId;
    let iceCandidate = data.iceCandidate;
      var userUsername = data.callerId;

      const targetSocket = socketUsernameMap[calleeId];
      if (targetSocket) {

        targetSocket.emit("IceCandidate", {
          sender: userUsername,
          iceCandidate: iceCandidate,
        });
      }
    
  });
  socket.on("leaveCall", (data) => {
    let user1 = data.user1;
      var user2 = data.user2;

      const targetSocket = socketUsernameMap[user1];
      if (targetSocket) {
        targetSocket.emit("callEnded", {
        });
      }
      const userSocket = socketUsernameMap[user2];
      if (userSocket) {
        userSocket.emit("callEnded", {
        });
      }
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