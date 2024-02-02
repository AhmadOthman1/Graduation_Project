import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/Groups_controller/groupchat_controller.dart';
import 'package:growify/controller/home/chats_controller/chatspage_cnotroller.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/global.dart';
import 'package:growify/resources/jitsi_meet.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/CalendarGroup.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/MeetingsHistory.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/TaskGroup/taskgroupmainpage.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/meeting.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/settingGroupPage.dart';
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

class GroupChatPageMessages extends StatefulWidget {
  final data;
  final admins;
  final members;
  final isUserAdminInPage;
  const GroupChatPageMessages({
    super.key,
    this.data,
    this.admins,
    this.members,
    this.isUserAdminInPage,
  });

  @override
  GroupChatPageMessagesState createState() => GroupChatPageMessagesState();
}

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

final ScrollController scrollController = ScrollController();

class GroupChatPageMessagesState extends State<GroupChatPageMessages> {
  late GroupChatController chatController;
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool doesUsernameIsAdmin = false;
  bool canSendMessage = false;
  @override
  void initState() {
    super.initState();
    chatController = GroupChatController();
    _socketConnect();
    _loadData();

    // to check if the user is Admin
    String username = GetStorage().read("username");
    canSendMessage = widget.data['membersendmessage'];

    _scrollController.addListener(_scrollListener);

    for (var admin in widget.admins) {
      if (admin['username'] == username) {
        doesUsernameIsAdmin = true;
        break;
      }
    }

    if (doesUsernameIsAdmin) {
      print('$username exists in the list of admins.');
    } else {
      print('$username does not exist in the list of admins.');
    }
  }

  _socketConnect() async {
    try {
      socket = IO.io(urlSSEStarter, <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });
      socket.connect();
      var accessToken = GetStorage().read("accessToken");
      socket.emit("/joinRoom", {
        "token": accessToken,
        "groupId": widget.data['id']
      }); //authenticate the user
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
              chatController.addMessage(msg["message"], msg["sender"],
                  msg["photo"], msg["date"], msg["image"], msg["video"]);
            }),
            socket.on("/chatMyVideo", (msg) {
              chatController.sendMessage(
                  msg["message"], msg["image"], msg["video"]);
            }),
          });

      print(socket.connected);
    } catch (err) {
      print(err);
    }
  }

  _loadData() async {
    print('Loading data...');
    try {
      await chatController.loadUserMessages(
          chatController.page, widget.data['id']);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(),
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
          if (/*incomingSDPOffer == null&&*/ (doesUsernameIsAdmin == true ||
              canSendMessage == true ||
              (widget.isUserAdminInPage != null &&
                  widget.isUserAdminInPage == true)))
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
                      width: 120,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              widget.data['name'],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_box),
                            color: Colors.white,
                            onPressed: () async {
                              await _showConferenceDialog(context);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today_rounded),
                            color: Colors.white,
                            onPressed: () {
                              Get.to(CalenderGroup(
                                  isAdmin: doesUsernameIsAdmin,
                                  members: widget.members,
                                  isUserAdminInPage: widget.isUserAdminInPage,
                                  groupData: widget.data));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.task),
                            color: Colors.white,
                            onPressed: () {
                              Get.to(TasksGroupHomePage(
                                  isAdmin: doesUsernameIsAdmin,
                                  members: widget.members,
                                  isUserAdminInPage: widget.isUserAdminInPage,
                                  groupData: widget.data));
                            },
                          ),
                          if (doesUsernameIsAdmin ||
                              (widget.isUserAdminInPage != null &&
                                  widget.isUserAdminInPage == true))
                            IconButton(
                              icon: const Icon(Icons.settings),
                              color: Colors.white,
                              onPressed: () {
                                Get.to(GroupSettings(
                                    admins: widget.admins,
                                    members: widget.members,
                                    groupData: widget.data));
                              },
                            ),
                          if (!doesUsernameIsAdmin &&(widget.isUserAdminInPage == false||widget.isUserAdminInPage == null)
                            )
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert,color:Colors.white ,),
                              color: Colors.white,
                              onSelected: (String value) {
                                // Handle menu item selection
                                if (value == 'leave_group') {
                                  // Add your leaving group logic here
                                  // For example: Navigator.pop(context);
                                  print('Leave Group selected');
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'leave_group',
                                  child: Text('Leave Group'),
                                ),
                              ],
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

  _showConferenceDialog(BuildContext context) async {
    TextEditingController meetingIDController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Meeting'),
          content: Container(
            height: 200,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: meetingIDController,
                    decoration: InputDecoration(
                      hintText: "Enter Meeting ID to join",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      labelText: "Meeting ID",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Meeting ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 380,
                    child: MaterialButton(
                      color: const Color.fromARGB(255, 85, 191, 218),
                      onPressed: () {
                        Get.to(ShowMeetingsHistory(
                          groupData: widget.data,
                        ));
                      },
                      child: Text(
                        'Show Meetings History',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  var message = await chatController.joinMeeting(
                      meetingIDController.text, widget.data["id"]);
                  if (message != null && message != "joined")
                    (message != null)
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomAlertDialog(
                                title: 'Alret',
                                icon: Icons.error,
                                text: message,
                                buttonText: 'OK',
                              );
                            },
                          )
                        : null;
                  if (message != null && message == "joined") {
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => meetingPage(
                                meetingID: meetingIDController.text.trim(),
                                userId: GetStorage().read("username"),
                                userName: GetStorage().read("firstname") +
                                    " " +
                                    GetStorage().read("lastname"),
                                photo: GetStorage().read("photo"),
                                groupId: widget.data["id"].toString(),
                                socket: socket,
                              )),
                    );
                  }
                  /*
                    Get.to(VideoConferencePage(
                      meetingID: meetingIDController.text,
                      userId: GetStorage().read("username"),
                      userName: GetStorage().read("firstname") +
                          " " +
                          GetStorage().read("lastname"),
                      groupId: widget.data["id"].toString(),
                      socket: socket,
                    ));*/
                }
              },
              child: const Text('Join'),
            ),
            if (doesUsernameIsAdmin ||
                (widget.isUserAdminInPage != null &&
                    widget.isUserAdminInPage == true))
              TextButton(
                onPressed: () async {
                  var meetingID =
                      await chatController.createMeeting(widget.data["id"]);
                  var accessToken = GetStorage().read("accessToken");
                  var m =
                      "${GetStorage().read("username")} invites you to a meeting, meeting ID: ${meetingID}";
                  chatController.sendMessage(m, null, null);
                  //emit message to server
                  socket.emit("/chatGroup", {
                    "message": m,
                    "token": accessToken,
                    "photo": GetStorage().read("photo"),
                    "groupId": widget.data["id"],
                    "messageImageBytes": null,
                    "messageImageBytesName": null,
                    "messageImageExt": null,
                    "messageVideoBytes": null,
                    "messageVideoBytesName": null,
                    "messageVideoExt": null,
                  });
                  if (meetingID != null) {
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => meetingPage(
                                meetingID: meetingID,
                                userId: GetStorage().read("username"),
                                userName: GetStorage().read("firstname") +
                                    " " +
                                    GetStorage().read("lastname"),
                                photo: GetStorage().read("photo"),
                                groupId: widget.data["id"].toString(),
                                socket: socket,
                              )),
                    );

                    /*Get.to(meetingPage(
                      meetingID: meetingID,
                      userId: GetStorage().read("username"),
                      userName: GetStorage().read("firstname") +
                          " " +
                          GetStorage().read("lastname"),
                      photo: GetStorage().read("photo"),
                      groupId: widget.data["id"].toString(),
                      socket: socket,
                    ));*/
                  }
                  /*Get.to(VideoConferencePage(
                    meetingID: meetingID,
                    userId: GetStorage().read("username"),
                    userName: GetStorage().read("firstname") +
                        " " +
                        GetStorage().read("lastname"),
                    groupId: widget.data["id"].toString(),
                    socket: socket,
                  ));*/
                },
                child: const Text('Create'),
              ),
          ],
        );
      },
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
                socket.emit("/chatGroup", {
                  "message": chatController.textController.text,
                  "token": accessToken,
                  "photo": GetStorage().read("photo"),
                  "groupId": widget.data["id"],
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
                socket.emit("/chatGroup", {
                  "message": chatController.textController.text,
                  "token": accessToken,
                  "photo": GetStorage().read("photo"),
                  "groupId": widget.data["id"],
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
