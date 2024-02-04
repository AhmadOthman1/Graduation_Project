const express = require('express');
const http = require('http');
const userRoutes = require('./routes/userNotifications');
const { socketAuthenticateToken, socketPageAuthenticateToken } = require('./controller/authController');
const { notifyUser, deleteNotificaion } = require("./controller/notifications");
const jwt = require('jsonwebtoken');
require('dotenv').config();
const { messagesControl, messageSaveImage, messageSaveVideo, groupMessagesControl, pageMessagesControl, messagesToPageControl } = require("./controller/chats/userChat");
var cors = require('cors');
const { populateClientsMap } = require('./controller/notifications');
const userChat = require('./controller/chats/userChat')
const bodyParser = require("body-parser");
const webrtc = require("wrtc");


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
app.use(express.static("public"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use('/userNotifications', userRoutes);
let senderStreams = [];
let socketIdConnectionsSenders = [];
let socketIdConnectionsReceivers = [];
let groupUsers = [];
let meetingUsers = [];
const socketUsernameMap = {};//map the usernames to their sockets
const socketPageIdMap = {};//map the pageId to their sockets
constraints = {
  'mandatory': {
    'OfferToReceiveVideo': true,
    'OfferToReceiveAudio': true,
  },
  'optional': [],
};
populateClientsMap();
function handleTrackEvent(e, socketId, meetingID, userName) {
  return new Promise((resolve) => {
    console.log(senderStreams);
    console.log("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu3");
    const index = senderStreams.findIndex((item) => socketId == item.socketId);
    if (index !== -1) {
      console.log(senderStreams);
      senderStreams[index].stream = e.streams[0];
      console.log("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu4");
    } else {
      senderStreams.push({
        socketId: socketId,
        stream: e.streams[0],
        meetingID: meetingID,
        userName: userName
      });
    }
    resolve(true);
  });
}
// handle peer sending stream to other peers 
async function createPeerConnectionSend(sdp, socketId, meetingID, userName) {
  //server peer

  const peer = new webrtc.RTCPeerConnection({
    'iceServers': [
      { 'urls': 'stun:freeturn.net:5349' },
      {
        'urls': 'turns:freeturn.tel:5349',
        'username': 'free',
        'credential': 'free'
      },
    ],
    'optional': [
      { 'DtlsSrtpKeyAgreement': true },
      { 'RtpDataChannels': true }
    ],
    'sdpSemantics': "unified-plan",
  });
  console.log(senderStreams)
  console.log("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu2")
  // store user stream 
  peer.ontrack = async (e) => {
    await handleTrackEvent(e, socketId, meetingID, userName);
    // The rest of your code that depends on handleTrackEvent being completed
  };
  // make stp offer from the server
  const sdpDesc = {
    type: "offer",
    sdp: sdp,
  };

  const desc = new webrtc.RTCSessionDescription(sdpDesc);
  await peer.setRemoteDescription(desc);
  const answer = await peer.createAnswer({
    'mandatory': {
      'OfferToReceiveVideo': true,
      'OfferToReceiveAudio': true,
    },
    'optional': [],
  });
  await peer.setLocalDescription(answer);
  const index = socketIdConnectionsSenders.findIndex((item) => socketId == item.socketId);
  if (index !== -1) {
    socketIdConnectionsSenders[index].pc = peer;
    console.log("ggggggggggggggggggggggggggggggggggggggggggggggggggggggggg");
  } else {
    socketIdConnectionsSenders.push(
      {
        socketId: socketId,
        userName: userName,
        pc: peer,
      }
    )
  }


  const payload = peer.localDescription.sdp;
  return payload;
}
//handle sending stream from server to peers
async function createPeerConnectionReceive(userSocketId, sdp, socketId) {//(my socket ,other user sdp, other user socket i want to receive from)
  const peer = new webrtc.RTCPeerConnection({
    'iceServers': [
      { 'urls': 'stun:freeturn.net:5349' },
      {
        'urls': 'turns:freeturn.tel:5349',
        'username': 'free',
        'credential': 'free'
      },
    ],
    'optional': [
      { 'DtlsSrtpKeyAgreement': true },
      { 'RtpDataChannels': true }
    ],
    'sdpSemantics': "unified-plan",
  });
  const sdpDesc = {
    type: "offer",
    sdp: sdp,
  };
  const desc = new webrtc.RTCSessionDescription(sdpDesc);
  await peer.setRemoteDescription(desc);
  let senders = []
  const index = senderStreams.findIndex((e) => e.socketId == socketId);
  if (senderStreams.length > 0) {
    await senderStreams[index].stream
      .getTracks()
      .forEach(async (track) => { senders.push(await peer.addTrack(track, senderStreams[index].stream)) });
  }
  const answer = await peer.createAnswer({
    'mandatory': {
      'OfferToReceiveVideo': true,
      'OfferToReceiveAudio': true,
    },
    'optional': [],
  });
  await peer.setLocalDescription(answer);
  const i = socketIdConnectionsReceivers.findIndex((item) => socketId == item.socketId && userSocketId == item.userSocketId);
  if (i !== -1) {
    socketIdConnectionsReceivers[i].pc = peer;
    socketIdConnectionsReceivers[i].senders = senders;

    console.log("ggggggggggggggggggggggggggggggggggggggggggggggggggggggggg");
  } else {
    socketIdConnectionsReceivers.push(
      {
        userSocketId: userSocketId,
        socketId: socketId,
        pc: peer,
        senders: senders,
      }
    )
  }

  const payload = peer.localDescription.sdp;
  return payload;
}
const callsUsernameMap = {};
io.on("connection", (socket) => {// first time socket connection
  console.log("connected");
  console.log(socket.id);

  socket.on("joinMeeting", async (msg) => {//when peer join a meeting
    try {
      console.log("ssssssssssssssssssssssssssssssssssssssssss");
      console.log(msg.meetingID);
      console.log(senderStreams)
      console.log("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu1")
      const payload = await createPeerConnectionSend(msg.sdp, socket.id, msg.meetingID, msg.userName);//create peer connection between user and server
      //extract all other peers socket ids
      /*const listSocketId = senderStreams
        .filter((e) => e.socketId != socket.id && e.meetingID == msg.meetingID)
        .map((e) => e.socketId);*/
      const listSocketId = senderStreams
        .filter((e) => e.socketId != socket.id && e.meetingID == msg.meetingID)
        .map((e) => ({ socketId: e.socketId, userName: e.userName }));
      console.log(";;;;;;;;;;;;;;;;;;;;")
      console.log(listSocketId)
      console.log(";;;;;;;;;;;;;;;;;;;;")
      console.log("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++(add new user peer as sender)")
      console.log(socketIdConnectionsSenders)
      console.log(socketIdConnectionsReceivers)
      console.log("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
      // Send sdp answer to the sender
      io.to(socket.id).emit("joined", {
        socketId: socket.id,
        sdp: payload,
        sockets: listSocketId,
      });
      // Broadcast to other meeting participants about the new peer
      socket.broadcast.to(msg.meetingID).emit("newPeerJoined", {
        socketId: socket.id,
        userName: msg.userName
      });
      console.log("====================================")
      console.log(senderStreams);
      console.log("====================================")
      socket.join(msg.meetingID);
    } catch (err) {
      console.log(err)
    }
  });
  socket.on("refresh", async (msg) => {//when peer join a meeting
    try {
      console.log("ssssssssssssssssssssssssssssssssssssssssss");
      console.log(msg.meetingID);
      console.log(senderStreams)
      console.log("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu1")
      senderPeerRefresh = socketIdConnectionsSenders.filter((e) => e.socketId == socket.id);
      const payload = senderPeerRefresh.pc.localDescription.sdp;//create peer connection between user and server
      console.log(payload);
      //extract all other peers socket ids
      const listSocketId = senderStreams
        .filter((e) => e.socketId != socket.id && e.meetingID == msg.meetingID)
        .map((e) => e.socketId);
      console.log(";;;;;;;;;;;;;;;;;;;;")
      console.log(listSocketId)
      console.log(";;;;;;;;;;;;;;;;;;;;")
      console.log("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++(add new user peer as sender)")
      console.log(socketIdConnectionsSenders)
      console.log(socketIdConnectionsReceivers)
      console.log("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
      // Send sdp answer to the sender
      io.to(socket.id).emit("joined", {
        socketId: socket.id,
        sdp: payload,
        sockets: listSocketId,
      });
      // Broadcast to other meeting participants about the new peer
      socket.broadcast.to(msg.meetingID).emit("newPeerJoined", {
        socketId: socket.id,
      });
      console.log("====================================")
      console.log(senderStreams);
      console.log("====================================")
      socket.join(msg.meetingID);
    } catch (err) {
      console.log(err)
    }
  });
  // New user will receive a stream from the peer that got his id from nowPeerJoined
  socket.on("RECEIVE-CSS", async function (data) {
    try {
      console.log(data.socketId);
      console.log("rrrrrrrrrrrrrrrrrrrrrrrrrr");
      const payload = await createPeerConnectionReceive(socket.id, data.sdp, data.socketId);
      console.log("*************************************************(add all other peers for the new peer as receivers) ")
      console.log(socketIdConnectionsSenders)
      console.log(socketIdConnectionsReceivers)

      console.log("*************************************************")
      // Send SDP answer to peers to listen to the user stream  
      io.to(socket.id).emit("RECEIVE-SSC", {
        socketId: data.socketId,
        sdp: payload,
      });
    } catch (err) {
      console.log(err)
    }
  });
  socket.on("leaveGroupMeeting", async (msg) => {
    try {
      console.log(msg.meetingID)
      console.log("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      // Broadcast to other meeting participants about the leaving peer



      const leavingUser = senderStreams.find((e) => (e.socketId === socket.id && e.meetingID == msg.meetingID));
      // Close the peer connection associated with the leaving user
      if (leavingUser) {

        for (const sr of socketIdConnectionsReceivers) {
          if (sr.userSocketId == socket.id) {
            console.log("closed");
            sr.pc.ontrack = async (e) => await e.streams[0].getTracks()
              .forEach(async (track) => await track.stop());
            /*for (let sender of sr.senders) {
              await sr.pc.removeTrack(sender);
            }*/
            await sr.pc.close();

          }

          if (sr.socketId == socket.id) {
            console.log("closed");
            sr.pc.ontrack = async (e) => await e.streams[0].getTracks()
              .forEach(async (track) => await track.stop());
            /*for (let sender of sr.senders) {
              await sr.pc.removeTrack(sender);
            }*/
            await sr.pc.close();

          }
        }
        //socketIdConnectionsReceivers = socketIdConnectionsReceivers.filter((e) => e.userSocketId != socket.id);

        //socketIdConnectionsReceivers = socketIdConnectionsReceivers.filter((e) => e.socketId != socket.id);
        for (const ss of socketIdConnectionsSenders) {
          if (ss.socketId == socket.id) {
            console.log("closed");
            await ss.pc.close();

          }


        };
        //socketIdConnectionsSenders = socketIdConnectionsSenders.filter((e) => e.socketId != socket.id);
        // Stop and remove tracks from the stream
        await senderStreams.find((e) => (e.socketId == socket.id && e.meetingID == msg.meetingID))?.stream?.getTracks().forEach(async (track) => { await track.stop(); });
        // Remove the leaving user from senderStreams
        senderStreams = senderStreams.filter((e) => e.socketId != socket.id);
        console.log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        console.log(socketIdConnectionsSenders)
        console.log(socketIdConnectionsReceivers)
        console.log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")


        socket.broadcast.to(msg.meetingID).emit("peerLeaved", {
          socketId: socket.id,
        });


        console.log("----------------------------------------------------");
        console.log(socket.id);
        console.log("----------------------------------------------------");
        console.log(msg.meetingID);
        console.log(socket.id);
        console.log(senderStreams);
        console.log(senderStreams[0]?.socketId);
        console.log(senderStreams[0]?.stream.getTracks());
        console.log(senderStreams[0]?.stream.getTracks().forEach(async (track) => { console.log(track) }));
      }
    } catch (err) {
      console.log(err)
    }
  });
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
          return;
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
        socket.broadcast.to(msg.groupId).emit("/chat", { sender: userUsername, photo: msg.photo, message: msg.message, image: messageImageName, video: messageVideoName, date: new Date() });

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
      return;
    } else if (status == 409) {//not authenticated to send messages using this token
      socket.emit("/chatStatus", {
        "status": status,
        "message": msg.message,
        "groupId": msg.groupId,
        "messageImageBytes": msg.messageImageBytes,
        "messageImageBytesName": msg.messageImageBytesName,
        "messageImageExt": msg.messageImageExt,
      });
      return;
    }
  });

  socket.on("/login", async (msg) => {//socketAuthenticate logain and save the user socket and map it to his username
    if (msg != null)
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
            photo: callsUsernameMap[userUsername].photo,
            isVideo: callsUsernameMap[userUsername].isVideo,
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
  socket.on("/PageLogin", async (msg) => {//socketAuthenticate login and save the page socket and map it to its pageId
    if (msg != null)
      var status = socketPageAuthenticateToken(msg);// check token
    console.log(status)
    if (status == 200) {// if page authenticated 
      const authHeader = msg
      const decoded = jwt.verify(authHeader, process.env.ACCESS_TOKEN_SECRET);
      var pageId = decoded.pageId;//take the username
      console.log(pageId);
      socketPageIdMap[pageId] = socket;// save the user socket in the socketUsernameMap with the username
      socket.emit("status", status);
    } else if (status == 403) {
      socket.emit("status", status);
    } else if (status == 409) {
      socket.emit("status", status);
    }
  });
  socket.on("/pageChat", async (msg) => {//when a new message arrive 
    console.log(msg);
    console.log("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    const authHeader = msg.token;
    var status = socketPageAuthenticateToken(msg.token);// check token
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
            "messageImageBytes": msg.messageImageBytes,
            "messageImageBytesName": msg.messageImageBytesName,
            "messageImageExt": msg.messageImageExt,
          });
          return;
        }
        var pageId = decoded.pageId;
        var messageImageName;
        var messageVideoName;
        const username = msg.username;
        const targetSocket = socketUsernameMap[username];//find receiver
        //if theres image save it
        if (msg.messageImageBytes != null && msg.messageImageBytesName != null && msg.messageImageExt != null)
          messageImageName = await messageSaveImage(pageId, msg.messageImageBytes, msg.messageImageBytesName, msg.messageImageExt)
        // if there is a video save it and send it back to the user
        if (msg.messageVideoBytes != null && msg.messageVideoBytesName != null && msg.messageVideoExt != null) {
          messageVideoName = await messageSaveVideo(pageId, msg.messageVideoBytes, msg.messageVideoBytesName, msg.messageVideoExt)
          var userSocket = socketPageIdMap[pageId];
          if (userSocket)
            userSocket.emit("/chatMyVideo", { message: msg.message, image: messageImageName, video: messageVideoName });
        }
        //if target user is in message page send it via his socket
        if (targetSocket) {
          console.log(msg.message);
          targetSocket.emit("/chat", { sender: pageId, message: msg.message, image: messageImageName, video: messageVideoName, date: new Date() });
        } /*else {// if not, send him a notification
          console.log(username)
          const notification = {
            username: username,
            notificationType: 'message', // Type of notifications
            notificationContent: "sent you a message",
            notificationPointer: pageId,
          };
          var isnotify = false
          isnotify = await notifyUser(username, notification);
          console.log(isnotify);
        }*/
        //save the message in db after sending it via socket
        await pageMessagesControl(pageId, username, msg.message, messageImageName, messageVideoName)//store it in the database
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
      return;
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
      return;
    }

  });
  socket.on("/chatToPage", async (msg) => {//when a new message arrive 
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
          return;
        }
        var userUsername = decoded.username;
        var messageImageName;
        var messageVideoName;
        const pageId = msg.pageId;
        const targetSocket = socketPageIdMap[pageId];//find receiver
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
          targetSocket.emit("/chat", { sender: userUsername, message: msg.message, image: messageImageName, video: messageVideoName, date: new Date() });
        }
        //save the message in db after sending it via socket
        await messagesToPageControl(userUsername, pageId, msg.message, messageImageName, messageVideoName)//store it in the database
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
      return;
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
      return;
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
          return;
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
          targetSocket.emit("/chat", { sender: userUsername, message: msg.message, image: messageImageName, video: messageVideoName, date: new Date() });
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
      return;
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
      return;
    }

  });
  //create new call offer from sender
  socket.on("makeCall", async (data) => {
    let calleeId = data.calleeId;
    let sdpOffer = data.sdpOffer;
    let photo = data.photo;
    var userUsername = data.callerId;
    let isVideo = data.isVideo;
    console.log(isVideo);
    console.log(":;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;")
    const targetSocket = socketUsernameMap[calleeId];
    if (targetSocket) {//if other user's socket is open
      targetSocket.emit("newCall", {
        callerId: userUsername,
        sdpOffer: sdpOffer,
        photo: photo,
        isVideo: isVideo,
      });
    } else {//send a notification
      callsUsernameMap[calleeId] = { userUsername, sdpOffer, photo, isVideo };
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
  socket.on("makePageCall", async (data) => {
    let calleeId = data.calleeId;
    let sdpOffer = data.sdpOffer;
    let photo = data.photo;
    var userUsername = data.callerId;
    let isVideo = data.isVideo;
    console.log(isVideo);
    console.log(":;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;")
    const targetSocket = socketUsernameMap[calleeId];
    if (targetSocket) {//if other user's socket is open
      targetSocket.emit("newCall", {
        callerId: userUsername,
        sdpOffer: sdpOffer,
        photo: photo,
        isVideo: isVideo,
      });
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
  socket.on("answerPageCall", (data) => {
    let callerId = data.callerId;
    let sdpAnswer = data.sdpAnswer;
    var userUsername = data.calleeId;
    if (callsUsernameMap[data.calleeId]) callsUsernameMap[data.calleeId] = null;
    const targetSocket = socketPageIdMap[callerId];
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
  socket.on("leavePageCall", (data) => {
    let user1 = data.user1;
    var user2 = data.user2;
    //out from both users
    const targetSocket = socketUsernameMap[user1];
    if (targetSocket) {
      targetSocket.emit("callEnded", {
      });
    }
    const userSocket = socketPageIdMap[user2];
    if (userSocket) {
      userSocket.emit("callEnded", {
      });
    }
  });

  socket.on("disconnect", async () => {
    //sockets leave all the channels they were part of automatically
    socketIdConnectionsReceivers = socketIdConnectionsReceivers.filter((e) => e.userSocketId != socket.id);

    socketIdConnectionsReceivers = socketIdConnectionsReceivers.filter((e) => e.socketId != socket.id);
    socketIdConnectionsSenders = socketIdConnectionsSenders.filter((e) => e.socketId != socket.id);
    await senderStreams.find((e) => (e.socketId == socket.id))?.stream?.getTracks().forEach(async (track) => { await track.stop(); });
    senderStreams = senderStreams.filter((e) => e.socketId != socket.id);
    groupUsers = groupUsers.filter(u => u.id != socket.id)
    const username = Object.keys(socketUsernameMap).find(
      (key) => socketUsernameMap[key] === socket
    );
    if (username) {
      delete socketUsernameMap[username];
    }
    console.log("====================================================")
    console.log(socket.id)
    console.log("====================================================")
    console.log(senderStreams)

  });
})
server.listen(4000, () => {

  console.log('Server listening on port 4000');
});