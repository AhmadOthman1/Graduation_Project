import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/chats_controller/chatspage_cnotroller.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/resources/jitsi_meet.dart';
import 'package:growify/view/screen/homescreen/chat/CallScreen.dart';
import 'package:growify/view/widget/homePage/chatmessage.dart';
import 'package:peerdart/peerdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:http/http.dart' as http;

class ChatPageMessages extends StatefulWidget {
  final data;
  const ChatPageMessages({super.key, this.data});

  @override
  ChatPageMessagesState createState() => ChatPageMessagesState();
}

final ScrollController scrollController = ScrollController();

class ChatPageMessagesState extends State<ChatPageMessages> {
  late ChatController chatController;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  late IO.Socket socket;
  var receivedCallAudio;
  var receivedCallAudioCounter = 0;
  String? messageImageBytes;
  String? messageImageBytesName;
  String? messageImageExt;
  String? messageVideoBytes;
  String? messageVideoBytesName;
  String? messageVideoExt;
  ImageProvider<Object> profileBackgroundImage =
      AssetImage("images/profileImage.jpg");

  final LogOutButtonControllerImp _logoutController =
      Get.put(LogOutButtonControllerImp());
  _initCallingListener() async {
    /*var authUrl = '$urlSSEStarter/userNotifications/notificationsAuth';
    var responce = await http.get(Uri.parse(authUrl), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });*/

    if (receivedCallAudio != null) {
      receivedCallAudio.currentPosition.listen((position) {
        if (receivedCallAudio != null &&
            position != null &&
            receivedCallAudio.current != null &&
            receivedCallAudio.current.hasValue &&
            receivedCallAudio.current.value != null) {
          print(position);
          print(receivedCallAudio.current.value?.audio.duration);
          print(receivedCallAudioCounter);

          if (position.inMilliseconds >= 4700) {
            receivedCallAudioCounter++;
            print(mounted);
            if (mounted) setState(() {});

            //position.inMilliseconds = 0;
            if (receivedCallAudioCounter >= 5) {
              decline();
              incomingSDPOffer = null;
              if (mounted) setState(() {});
            }
          }
        }
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    receivedCallAudio = AssetsAudioPlayer();
    receivedCallAudioCounter = 0;
    incomingSDPOffer = null;
    chatController = ChatController();
    _socketConnect();
    _initCallingListener();
    _loadData();

    _scrollController.addListener(_scrollListener);
  }

  _socketConnect() async {
    try {
      /*var authUrl = '$urlSSEStarter/userNotifications/notificationsAuth';
      var responce = await http.get(Uri.parse(authUrl), headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      });*/
      socket = IO.io(urlSSEStarter, <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });
      socket.connect();
      var accessToken = GetStorage().read("accessToken");
      socket.emit("/login", accessToken); //authenticate the user
      socket.onConnect((data) => {
            // read authentication status
            socket.on("status", (status) async {
              if (status == 403) {
                //accessToken expired
                await getRefreshToken(GetStorage().read('refreshToken'));
                accessToken = GetStorage().read("accessToken");
                _socketConnect();
                return;
              } else if (status == 401) {
                //not valid refreshToken
                _logoutController.goTosigninpage();
              } else if (status == 200) {
                //authenticated
              }
            }),
            socket.on("/chatStatus", (msg) async {
              //chat message token expired handle
              if (msg["status"] == 403) {
                await getRefreshToken(GetStorage().read('refreshToken'));
                //reSend the message
                accessToken = GetStorage().read("accessToken");
                socket.emit("/chat", {
                  "message": msg["message"],
                  "token": accessToken,
                  "username": widget.data["username"],
                  "messageImageBytes": msg["messageImageBytes"],
                  "messageImageBytesName": msg["messageImageBytesName"],
                  "messageImageExt": msg["messageImageExt"],
                  "messageVideoBytes": msg["messageVideoBytes"],
                  "messageVideoBytesName": msg["messageVideoBytesName"],
                  "messageVideoExt": msg["messageVideoExt"],
                });
                return;
              } else if (msg["status"] == 401) {
                _logoutController.goTosigninpage();
              }
            }),
            socket.on("/chat", (msg) {
              if (mounted) {
                setState(() {
                  chatController.messages;
                });
              }
              if(msg["sender"] == widget.data['username']){// handel of user A,B,C has socket, A send to B message, but B is in C conversation (Dont show A message is B conversation)
                chatController.addMessage(
                  msg["message"],
                  msg["sender"],
                  widget.data["photo"],
                  msg["date"],
                  msg["image"],
                  msg["video"]);
              }
              
            }),
            socket.on("/chatMyVideo", (msg) {
              chatController.sendMessage(
                  msg["message"], msg["image"], msg["video"]);
            }),
            socket.on("newCall", (data) {
              print(data);
              incomingSDPOffer = data;
              playCallingSound();
              print(mounted);
              if (mounted) {
                setState(() {});
              }
            }),
            socket!.on("callEnded", (data) async {
              incomingSDPOffer = null;
              stopCallingSound();
              if (mounted) setState(() {});
            }),
          });

      print(socket.connected);
    } catch (err) {
      print(err);
    }
  }

  void playCallingSound() {
    receivedCallAudio = AssetsAudioPlayer();
    if (kIsWeb) {
      receivedCallAudio.open(Audio.network("audio/receivedCall.mp3"),
          loopMode: LoopMode.single);
    } else {
      receivedCallAudio.open(Audio("audio/receivedCall.mp3"),
          loopMode: LoopMode.single);
    }
    _initCallingListener();
    receivedCallAudio.play();
  }

  stopCallingSound() {
    receivedCallAudio.pause();
    receivedCallAudioCounter = 0;
    //receivedCallAudio = AssetsAudioPlayer();
  }

  _loadData() async {
    print('Loading data...');
    try {
      await chatController.loadUserMessages(
          chatController.page, widget.data['username'], widget.data['type']);
      print(mounted);
      print("bbbbbbbbbbbbbbbbbbbbbbbb");
      if (mounted)
        setState(() {
          chatController.page++;
          chatController.messages;
        });
      print('Data loaded:');
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void _scrollListener() {
    print(_scrollController.offset);
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // reached the bottom, load more notifications
      _loadData();
    }
  }

  @override
  void dispose() {
    chatController.dispose();
    _scrollController.dispose();
    socket.clearListeners();
    socket.dispose();
    if (receivedCallAudio != null) {
      receivedCallAudio.stop();
      receivedCallAudio.dispose();
    }

    receivedCallAudio = null;
    print("aaaa");
    if (incomingSDPOffer != null)
      socket!.emit("leaveCall", {
        "user1": incomingSDPOffer["callerId"]!,
        "user2": GetStorage().read("username"),
      });
    super.dispose();
  }

  _joinCall({
    required String callerId,
    required String calleeId,
   
    dynamic offer,
     String? photo,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallScreen(
          callerId: callerId,
          calleeId: calleeId,
          offer: offer,
          photo : photo,
          socket: socket,
          onCallEnded: () {
            // rebuild the parent screen
            final chatPageState = widget.key;
            if (chatPageState != null && mounted) {
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  decline() {
    socket!.emit("leaveCall", {
      "user1": incomingSDPOffer["callerId"]!,
      "user2": GetStorage().read("username"),
    });
    stopCallingSound();
  }

/*
 final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();

  createNewMeeting() async {
    var random = Random();
    var username = GetStorage().read('username');
    DateTime now = DateTime.now();
    String roomName = username+ "-" + now.toString() + "+" +(random.nextInt(10000000) + 10000000).toString();
    print("aaaaaaaaaaaaaaaaa");
    _jitsiMeetMethods.createMeeting(
        roomName: roomName, isAudioMuted: true, isVideoMuted: true, username: username , email: GetStorage().read('loginemail') , subject: "Personal Meeting");
  }*/
  /*createPeerConn(
     callerId,
     calleeId,
  ) async{
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PeerCallScreen(
          callerId: callerId,
          calleeId: calleeId,
          socket: socket,
        ),
      ),
    );

  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (incomingSDPOffer == null) _buildAppBar(),
          if (incomingSDPOffer != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                ),
                // Circular photo in the middle
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: incomingSDPOffer["photo"] != null
                          ? Image.network("$urlStarter/${incomingSDPOffer["photo"]}")
                              .image
                          : profileBackgroundImage,
                    ),
                  ),
                ),

                // Text below the circular photo
                Container(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        "Incoming Call from ${incomingSDPOffer["callerId"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                ),
                // Row of buttons at the bottom
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 50,
                        icon: const Icon(Icons.call_end),
                        color: Colors.redAccent,
                        onPressed: () {
                          decline();
                          if (mounted) setState(() => incomingSDPOffer = null);
                        },
                      ),
                      IconButton(
                        iconSize: 50,
                        icon: const Icon(Icons.call),
                        color: Colors.greenAccent,
                        onPressed: () {
                          stopCallingSound();
                          _joinCall(
                            callerId: incomingSDPOffer["callerId"]!,
                            calleeId: GetStorage().read("username"),
                            offer: incomingSDPOffer["sdpOffer"],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (incomingSDPOffer == null)
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  reverse: true, // Display messages in reverse order
                  controller: _scrollController,
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    //return chatController.messages[index];
                    return ChatMessage(
                      text: chatController.messages[index].text,
                      isUser: chatController.messages[index].isUser,
                      userName: chatController.messages[index].userName,
                      userPhoto: chatController.messages[index].userPhoto,
                      createdAt: chatController.messages[index].createdAt,
                      image: chatController.messages[index].image,
                      video: chatController.messages[index].video,
                      existingVideoController: chatController
                          .messages[index].existingVideoController,
                    );
                  },
                );
              }),
            ),
          if (incomingSDPOffer == null) _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 20, bottom: 5, right: 10),
      color: Colors.blue,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (receivedCallAudio != null) {
                receivedCallAudio.stop();
                receivedCallAudio.dispose();
              }

              receivedCallAudio = null;
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      child: Text(
                        widget.data['name'],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.call),
                            color: Colors.white,
                            onPressed: () {
                              //createPeerConn(GetStorage().read('username'), widget.data["username"]);

                              //createNewMeeting();

                              _joinCall(
                                callerId: GetStorage().read("username"),
                                calleeId: widget.data["username"],
                                photo: GetStorage().read("photo"),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon:
                (messageImageBytes != null) //choose icon based on image status
                    ? const Icon(Icons.cancel)
                    : const Icon(Icons.photo),
            onPressed: () async {
              try {
                if (messageImageBytes != null) {
                  //if user repress image button
                  setState(() {
                    messageImageBytes = null;
                    messageImageBytesName = null;
                    messageImageExt = null;
                  });
                } else {
                  final result = await FilePicker.platform.pickFiles(
                    //choose image
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'jpeg', 'png'],
                    allowMultiple: false,
                  );
                  if (result != null && result.files.isNotEmpty) {
                    PlatformFile file = result.files.first;
                    if (file.extension == "jpg" ||
                        file.extension == "jpeg" ||
                        file.extension == "png") {
                      String base64String;
                      if (kIsWeb) {
                        final fileBytes = file.bytes;
                        base64String = base64Encode(fileBytes as List<int>);
                      } else {
                        List<int> fileBytes =
                            await File(file.path!).readAsBytes();
                        base64String = base64Encode(fileBytes);
                      }
                      setState(() {
                        messageImageBytes = base64String;
                        messageImageBytesName = file.name;
                        messageImageExt = file.extension;
                      });
                    } else {
                      setState(() {
                        messageImageBytes = null;
                        messageImageBytesName = null;
                        messageImageExt = null;
                      });
                    }
                  } else {
                    // User canceled the picker
                    setState(() {
                      messageImageBytes = null;
                      messageImageBytesName = null;
                      messageImageExt = null;
                    });
                  }
                }
              } catch (err) {
                print(err);
                setState(() {
                  messageImageBytes = null;
                  messageImageBytesName = null;
                  messageImageExt = null;
                });
              }
            },
          ),
          IconButton(
            icon: (messageVideoBytes != null)
                ? const Icon(Icons.cancel)
                : const Icon(Icons.videocam),
            onPressed: () async {
              try {
                if (messageVideoBytes != null) {
                  // User cancels the video selection
                  setState(() {
                    messageVideoBytes = null;
                    messageVideoBytesName = null;
                    messageVideoExt = null;
                  });
                } else {
                  // Open file picker for video
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['mp4', 'avi', 'mov'],
                    allowMultiple: false,
                  );

                  if (result != null && result.files.isNotEmpty) {
                    PlatformFile file = result.files.first;
                    if (file.extension == "mp4" ||
                        file.extension == "avi" ||
                        file.extension == "mov") {
                      // Process the selected video
                      String base64String;
                      if (kIsWeb) {
                        final fileBytes = file.bytes;
                        base64String = base64Encode(fileBytes as List<int>);
                      } else {
                        List<int> fileBytes =
                            await File(file.path!).readAsBytes();
                        base64String = base64Encode(fileBytes);
                      }

                      setState(() {
                        messageVideoBytes = base64String;
                        messageVideoBytesName = file.name;
                        messageVideoExt = file.extension;
                      });
                    } else {
                      // File is not a video
                      setState(() {
                        messageVideoBytes = null;
                        messageVideoBytesName = null;
                        messageVideoExt = null;
                      });
                    }
                  } else {
                    // User canceled the picker
                    setState(() {
                      messageVideoBytes = null;
                      messageVideoBytesName = null;
                      messageVideoExt = null;
                    });
                  }
                }
              } catch (err) {
                print(err);
                setState(() {
                  messageVideoBytes = null;
                  messageVideoBytesName = null;
                  messageVideoExt = null;
                });
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: chatController.textController,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
              ),
              maxLines: null, // Allows for multiple lines
              keyboardType: TextInputType.multiline, // Enables the Enter key
              onSubmitted: (value) {
                chatController.textController.text += '\n';
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              final messageText = chatController.textController.text.trim();
              if ((messageText.isNotEmpty || messageImageBytes != null) &&
                  messageVideoBytes == null) {
                //one of them not null
                chatController.sendMessage(chatController.textController.text,
                    messageImageBytes, messageVideoBytes);
                //show message to this user

                var accessToken = GetStorage().read("accessToken");
                //emit message to server
                socket.emit("/chat", {
                  "message": chatController.textController.text,
                  "token": accessToken,
                  "username": widget.data["username"],
                  "messageImageBytes": messageImageBytes,
                  "messageImageBytesName": messageImageBytesName,
                  "messageImageExt": messageImageExt,
                  "messageVideoBytes": messageVideoBytes,
                  "messageVideoBytesName": messageVideoBytesName,
                  "messageVideoExt": messageVideoExt,
                });
                if (mounted) {
                  setState(() {
                    chatController.messages;
                    messageImageBytes = null;
                    messageImageBytesName = null;
                    messageImageExt = null;

                    messageVideoBytes = null;
                    messageVideoBytesName = null;
                    messageVideoExt = null;
                  });
                }
                chatController.textController.clear();
              } else if (messageVideoBytes != null) {
                var accessToken = GetStorage().read("accessToken");
                //emit message to server
                socket.emit("/chat", {
                  "message": chatController.textController.text,
                  "token": accessToken,
                  "username": widget.data["username"],
                  "messageImageBytes": messageImageBytes,
                  "messageImageBytesName": messageImageBytesName,
                  "messageImageExt": messageImageExt,
                  "messageVideoBytes": messageVideoBytes,
                  "messageVideoBytesName": messageVideoBytesName,
                  "messageVideoExt": messageVideoExt,
                });
                if (mounted) {
                  setState(() {
                    messageImageBytes = null;
                    messageImageBytesName = null;
                    messageImageExt = null;

                    messageVideoBytes = null;
                    messageVideoBytesName = null;
                    messageVideoExt = null;
                  });
                }
                chatController.textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
