import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/chats_controller/chatspage_cnotroller.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPageMessages extends StatefulWidget {
  final data;
  ChatPageMessages({super.key, this.data});

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
  var accessToken = GetStorage().read("accessToken");
  LogOutButtonControllerImp _logoutController =
      Get.put(LogOutButtonControllerImp());
  @override
  void initState() {
    super.initState();
    chatController = ChatController();
    _loadData();
    socketConnect();
    _scrollController.addListener(_scrollListener);
    print("======================");
    print(widget.data);
  }

  void socketConnect() {
    try {
      socket = IO.io(urlSSEStarter, <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });
      socket.connect();
      socket.emit("/login", accessToken); //authenticate the user
      socket.onConnect((data) => {
            // read authentication status
            socket.on("status", (status) async {
              print(";;;;;;;;;;;;;;;;;;;;;;;");
              print(status);
              if (status == 403) {
                await getRefreshToken(GetStorage().read('refreshToken'));
                socketConnect();
                return;
              } else if (status == 401) {
                _logoutController.goTosigninpage();
              } else if (status == 200) {
                //authenticated
              }
            }),
            socket.on("/chat", (msg) {
              print(msg["message"]);
              print(widget.data["username"]);
              print(widget.data["photo"]);
              print(msg["date"]);

              chatController.addMessage(
                  msg["message"],
                  widget.data["username"],
                  widget.data["photo"],
                  msg["date"],
                  null);
            })
          });

      print(socket.connected);
    } catch (err) {
      print(err);
    }
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
      print('Data loaded: ${chatController.messages.length} notifications');
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
                  return chatController.messages[index];
                },
                // Add scroll listener
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
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
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
                    // Use Expanded for the icons on the right
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.video_call),
                            color: Colors.white,
                            onPressed: () {
                              // Add your video call logic here
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
            icon: const Icon(Icons.photo),
            onPressed: () {
              
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
            onPressed: () {
              chatController.sendMessage(chatController.textController.text);
              socket.emit("/chat", {
                "message": chatController.textController.text,
                "token": accessToken,
                "username": widget.data["username"]
              });
              chatController.textController.clear();
            },
          ),
        ],
      ),
    );
  }
}
