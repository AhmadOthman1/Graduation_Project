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

class ChatPageMessages extends StatefulWidget {
  final data;
  const ChatPageMessages({super.key, this.data});

  @override
  _ChatPageMessagesState createState() => _ChatPageMessagesState();
}

final ScrollController scrollController = ScrollController();

class _ChatPageMessagesState extends State<ChatPageMessages> {
  late ChatController chatController;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  late IO.Socket socket;
  final receivedCallAudio = AssetsAudioPlayer();
  var receivedCallAudioCounter = 0;
  String? messageImageBytes;
  String? messageImageBytesName;
  String? messageImageExt;
  String? messageVideoBytes;
  String? messageVideoBytesName;
  String? messageVideoExt;

  final LogOutButtonControllerImp _logoutController =
      Get.put(LogOutButtonControllerImp());

  @override
  void initState() {
    super.initState();
    receivedCallAudioCounter = 0;
    incomingSDPOffer = null;
    chatController = ChatController();
    _loadData();
    socketConnect();
    _scrollController.addListener(_scrollListener);
    receivedCallAudio.currentPosition.listen((position) {
      // Check if the position is at the end of the audio duration
      print(position);
      print(receivedCallAudio.current.value!.audio.duration);

      if (position.inMilliseconds >=
          receivedCallAudio.current.value!.audio.duration.inMilliseconds -
              1000) {
        receivedCallAudioCounter++;
        if (mounted) setState(() {});
        playCallingSound();
        if (receivedCallAudioCounter >= 5) {
          decline();
          stopCallingSound();
          incomingSDPOffer = null;
          if (mounted) setState(() {});
        }
      }
    });
  }

  void socketConnect() {
    try {
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
                socketConnect();
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
              chatController.addMessage(
                  msg["message"],
                  widget.data["username"],
                  widget.data["photo"],
                  msg["date"],
                  msg["image"],
                  msg["video"]);
            }),
            socket.on("/chatMyVideo", (msg) {
              chatController.sendMessage(
                  msg["message"], msg["image"], msg["video"]);
            }),
            socket.on("newCall", (data) {
              playCallingSound();
              print(data);
              incomingSDPOffer = data;
              if (mounted) {
                setState(() {
                  incomingSDPOffer = data;
                });
              }
            }),
            socket!.on("callEnded", (data) async {
              incomingSDPOffer = null;
              if (mounted) {
                setState(() {});
              }
            }),
          });

      print(socket.connected);
    } catch (err) {
      print(err);
    }
  }

  void playCallingSound() {
    if (kIsWeb) {
      receivedCallAudio.open(
        Audio.network("audio/receivedCall.mp3"),
      );
    } else {
      receivedCallAudio.open(
      Audio("audio/receivedCall.mp3"),
    );
    }

    receivedCallAudio.play();
  }

  void stopCallingSound() {
    receivedCallAudio.stop();
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await chatController.loadUserMessages(
          chatController.page, widget.data['username'], widget.data['type']);
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
    _scrollController.dispose();
    receivedCallAudio.dispose();

    super.dispose();
  }

  _joinCall({
    required String callerId,
    required String calleeId,
    dynamic offer,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallScreen(
          callerId: callerId,
          calleeId: calleeId,
          offer: offer,
          socket: socket,
          onCallEnded: () {
            // rebuild the parent screen
            setState(() {});
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
    receivedCallAudio.dispose();
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
          _buildAppBar(),
          if (incomingSDPOffer != null)
            Stack(
              children: [
                Positioned(
                  child: ListTile(
                    title: Text(
                      "Incoming Call from ${incomingSDPOffer["callerId"]}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.call_end),
                          color: Colors.redAccent,
                          onPressed: () {
                            stopCallingSound();
                            decline();
                            setState(() => incomingSDPOffer = null);
                          },
                        ),
                        IconButton(
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
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                    existingVideoController:
                        chatController.messages[index].existingVideoController,
                  );
                },
              );
            }),
          ),
          _buildMessageComposer(),
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
                setState(() {
                  chatController.messages;
                  messageImageBytes = null;
                  messageImageBytesName = null;
                  messageImageExt = null;

                  messageVideoBytes = null;
                  messageVideoBytesName = null;
                  messageVideoExt = null;
                });
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

                setState(() {
                  messageImageBytes = null;
                  messageImageBytesName = null;
                  messageImageExt = null;

                  messageVideoBytes = null;
                  messageVideoBytesName = null;
                  messageVideoExt = null;
                });
                chatController.textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
