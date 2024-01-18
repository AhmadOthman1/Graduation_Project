const express = require('express');
const http = require('http');
const userRoutes = require('./routes/userNotifications');
const { socketAuthenticateToken } = require('./controller/authController');
const { notifyUser, deleteNotificaion } = require("./controller/notifications");
const jwt = require('jsonwebtoken');
require('dotenv').config();
const { messagesControl, messageSaveImage, messageSaveVideo ,groupMessagesControl} = require("./controller/chats/userChat");
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
app.use(express.json());
app.use(express.static('messageVideos'));
app.use(express.static('videos'));
app.use(express.static('messageImages'));
app.use(express.static('images'));
app.use(express.static('cvs'));

app.use('/userNotifications', userRoutes);

populateClientsMap();

let groupUsers=[];
const socketUsernameMap = {};//map the usernames to their sockets
const callsUsernameMap = {};
io.on("connection", (socket) => {// first time socket connection
  console.log("connected");
  console.log(socket.id);
  socket.on("/joinRoom", (msg) => {
    var status = socketAuthenticateToken(msg.token);// check token
    console.log(status)
    if (status == 200) {// if user authenticated 
      const authHeader = msg.token
      const decoded = jwt.verify(authHeader, process.env.ACCESS_TOKEN_SECRET);
      var userUsername = decoded.username;//take the username
      const user = {
        userUsername,
        id: socket.id
      }
      groupUsers.push(user)
      socket.join(msg.groupId)
      console.log(msg.token)
      console.log(msg.groupId)
      console.log(groupUsers)
      socket.emit("status", status);
    } else if (status == 403) {
      socket.emit("status", status);
    } else if (status == 409) {
      socket.emit("status", status);
    }
  });
  socket.on("/chatGroup", async (msg) => {
    console.log(msg);
    const authHeader = msg.token;
    var status = socketAuthenticateToken(msg.token);// check token
    if (status == 200) {//authenticated
      console.log(msg.message);
      console.log(msg.messageVideoBytes);//messageVideoBytes
      if (msg.message != null || msg.messageImageBytes != null || msg.messageVideoBytes != null) {// if its a valid message
        var decoded;
        try {
          decoded = jwt.verify(authHeader, process.env.ACCESS_TOKEN_SECRET);//auth the user
        } catch (err) {
          socket.emit("/chatStatus", {
            "status": 403,
            "message": msg.message,
            "groupId": msg.groupId,
            "messageImageBytes": msg.messageImageBytes,
            "messageImageBytesName": msg.messageImageBytesName,
            "messageImageExt": msg.messageImageExt,
          });
        }
        var userUsername = decoded.username;
        var messageImageName;
        var messageVideoName;
        const groupId = msg.groupId;
        //if theres image save it
        if (msg.messageImageBytes != null && msg.messageImageBytesName != null && msg.messageImageExt != null)
          messageImageName = await messageSaveImage(userUsername, msg.messageImageBytes, msg.messageImageBytesName, msg.messageImageExt)
        // if there is a video save it and send it back to the user
        if (msg.messageVideoBytes != null && msg.messageVideoBytesName != null && msg.messageVideoExt != null) {
          messageVideoName = await messageSaveVideo(userUsername, msg.messageVideoBytes, msg.messageVideoBytesName, msg.messageVideoExt)
            socket.to(userUsername).emit("/chatMyVideo", { message: msg.message, image: messageImageName, video: messageVideoName });
        }
        //if target user is in message page send it via his socket
          console.log(msg.message);
          socket.broadcast.to(msg.groupId).emit("/chat", {sender: userUsername,photo: msg.photo,  message: msg.message, image: messageImageName, video: messageVideoName, date: new Date() });
       
        //save the message in db after sending it via socket
        await groupMessagesControl(userUsername, msg.groupId, msg.message, messageImageName, messageVideoName)//store it in the database
      }
    } else if (status == 403) {//not authenticated to send messages using this token
      socket.emit("/chatStatus", {
        "status": status,
        "message": msg.message,
        "groupId": msg.groupId,
        "messageImageBytes": msg.messageImageBytes,
        "messageImageBytesName": msg.messageImageBytesName,
        "messageImageExt": msg.messageImageExt,
      });
    } else if (status == 409) {//not authenticated to send messages using this token
      socket.emit("/chatStatus", {
        "status": status,
        "message": msg.message,
        "groupId": msg.groupId,
        "messageImageBytes": msg.messageImageBytes,
        "messageImageBytesName": msg.messageImageBytesName,
        "messageImageExt": msg.messageImageExt,
      });
    }
  });
  socket.on("/login", (msg) => {//socketAuthenticate logain and save the user socket and map it to his username

    var status = socketAuthenticateToken(msg);// check token
    console.log(status)
    if (status == 200) {// if user authenticated 
      const authHeader = msg
      const decoded = jwt.verify(authHeader, process.env.ACCESS_TOKEN_SECRET);
      var userUsername = decoded.username;//take the username
      console.log(userUsername);
      socketUsernameMap[userUsername] = socket;// save the user socket in the socketUsernameMap with the username
      if (callsUsernameMap[userUsername] && callsUsernameMap[userUsername] != null) {// if there is a coming call from other user 
        const targetSocket = socketUsernameMap[userUsername];//get the user socket
        if (targetSocket) {//if other user's socket is open
          //send the user the call offer
          targetSocket.emit("newCall", {
            callerId: callsUsernameMap[userUsername].userUsername,
            sdpOffer: callsUsernameMap[userUsername].sdpOffer,
          });
        }
      }
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
      if (msg.message != null || msg.messageImageBytes != null || msg.messageVideoBytes != null) {// if its a valid message
        var decoded;
        try {
          decoded = jwt.verify(authHeader, process.env.ACCESS_TOKEN_SECRET);//auth the user
        } catch (err) {
          socket.emit("/chatStatus", {
            "status": 403,
            "message": msg.message,
            "username": msg.username,
            "username": msg.username,
            "messageImageBytes": msg.messageImageBytes,
            "messageImageBytesName": msg.messageImageBytesName,
            "messageImageExt": msg.messageImageExt,
          });
        }
        var userUsername = decoded.username;
        var messageImageName;
        var messageVideoName;
        const username = msg.username;
        const targetSocket = socketUsernameMap[username];//find receiver
        //if theres image save it
        if (msg.messageImageBytes != null && msg.messageImageBytesName != null && msg.messageImageExt != null)
          messageImageName = await messageSaveImage(userUsername, msg.messageImageBytes, msg.messageImageBytesName, msg.messageImageExt)
        // if there is a video save it and send it back to the user
        if (msg.messageVideoBytes != null && msg.messageVideoBytesName != null && msg.messageVideoExt != null) {
          messageVideoName = await messageSaveVideo(userUsername, msg.messageVideoBytes, msg.messageVideoBytesName, msg.messageVideoExt)
          var userSocket = socketUsernameMap[userUsername];
          if (userSocket)
            userSocket.emit("/chatMyVideo", { message: msg.message, image: messageImageName, video: messageVideoName });
        }
        //if target user is in message page send it via his socket
        if (targetSocket) {
          console.log(msg.message);
          targetSocket.emit("/chat", {sender: userUsername,  message: msg.message, image: messageImageName, video: messageVideoName, date: new Date() });
        } else {// if not, send him a notification
          console.log(username)
          const notification = {
            username: username,
            notificationType: 'message', // Type of notifications
            notificationContent: "sent you a message",
            notificationPointer: userUsername,
          };
          var isnotify = false
          isnotify = await notifyUser(username, notification);
          console.log(isnotify);
        }
        //save the message in db after sending it via socket
        await messagesControl(userUsername, username, msg.message, messageImageName, messageVideoName)//store it in the database
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
  //create new call offer from sender
  socket.on("makeCall", async (data) => {
    let calleeId = data.calleeId;
    let sdpOffer = data.sdpOffer;
    let photo = data.photo;
    var userUsername = data.callerId;
    const targetSocket = socketUsernameMap[calleeId];
    if (targetSocket) {//if other user's socket is open
      targetSocket.emit("newCall", {
        callerId: userUsername,
        sdpOffer: sdpOffer,
        photo:photo,
      });
    } else {//send a notification
      callsUsernameMap[calleeId] = { userUsername, sdpOffer };
      console.log(callsUsernameMap[calleeId])
      console.log(calleeId)
      console.log("---------------------------------")
      const notification = {
        username: calleeId,
        notificationType: 'call', // Type of notifications
        notificationContent: "wants to call you",
        notificationPointer: userUsername,
      };
      var isnotify = false
      isnotify = await notifyUser(calleeId, notification);
      console.log(isnotify);
    }
  });
  //answer the call from the receiver
  socket.on("answerCall", (data) => {
    let callerId = data.callerId;
    let sdpAnswer = data.sdpAnswer;
    var userUsername = data.calleeId;
    if (callsUsernameMap[data.calleeId]) callsUsernameMap[data.calleeId] = null;
    const targetSocket = socketUsernameMap[callerId];
    if (targetSocket) {
      targetSocket.emit("callAnswered", {
        callee: userUsername,
        sdpAnswer: sdpAnswer,
      });
    }

  });
  //get Ice Candidate from user and send it to other user 
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
  //when any user end the call/call request 
  socket.on("leaveCall", (data) => {
    let user1 = data.user1;
    var user2 = data.user2;
    //out from both users
    if (callsUsernameMap[user1]) callsUsernameMap[user1] = null;

    if (callsUsernameMap[user2]) callsUsernameMap[user2] = null;
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
    groupUsers = groupUsers.filter(u =>u.id != socket.id)
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