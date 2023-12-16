import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/chatspage_cnotroller.dart';

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


  @override
  void initState() {
    super.initState();
    chatController = ChatController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      
      await chatController.loadUserMessages(chatController.page, widget.data['username'], widget.data['type']);
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
                        style: const TextStyle(color: Colors.white, fontSize: 20),
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
              // Add your image upload logic here
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
            },
          ),
        ],
      ),
    );
  }
}
