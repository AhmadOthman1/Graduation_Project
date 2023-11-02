import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/view/widget/homePage/chatmessage.dart';


class ChatController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final textController = TextEditingController();

  void sendMessage(String text) {
    if (text.isNotEmpty) {
      messages.insert(
        0,
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );
      textController.clear();
    }
  }
}
