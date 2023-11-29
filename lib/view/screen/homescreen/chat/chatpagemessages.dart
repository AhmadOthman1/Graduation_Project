import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/chatspage_cnotroller.dart';

class ChatPageMessages extends StatelessWidget {
  final data;
   ChatPageMessages({super.key, this.data});
  final ChatController chatController = Get.put(ChatController());
  

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
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  return chatController.messages[index];
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: Colors.blue,
      child: Row(
        children: [
          const Icon(Icons.arrow_back, color: Colors.white),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      data['name'],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 140),

                  Container(
                    child: Row(children: [
                      IconButton(
                      icon: const Icon(Icons.video_call),
                      color: Colors.white,
                      onPressed: () {
                        // Add your video call logic here
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      color: Colors.white,
                      onPressed: () {
                        // Add your audio call logic here
                      },
                    ),
                    ],),
                  ),
                ],
              ),
            ],
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
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              // Add your camera capture logic here
            },
          ),
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