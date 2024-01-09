import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/widget/homePage/chatmessage.dart';
import 'package:http/http.dart' as http;
LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class GroupChatController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final textController = TextEditingController();
  bool isLoading = false;
  int pageSize = 15;
  int page = 1;

  void sendMessage( text, messageImageBytes,messageVideoBytes) {
    DateTime now = DateTime.now();
      messages.insert(
        0,
        ChatMessage(
          text: text,
          isUser: true,
          image: messageImageBytes,
          video: messageVideoBytes,
          createdAt: now.toString(),
        ),
      );
      
      update();
    
  }
addMessage( text,  username, userPhoto,  createdAt, image,video) async {
  
  for (var message in messages) {
  }
    ChatMessage chatMessage = ChatMessage(
          text: text?? '',
          isUser: false,
          userName: username,
          userPhoto: (userPhoto==null) ? '': userPhoto,
          createdAt: createdAt,
          image: image,
          video: video,
        );

        // Add the ChatMessage object to the list
        messages.insert(0, chatMessage);
        
  }
  getUserMessages(int page, int groupId, int pageId) async {
    
  }

  Future<void> loadUserMessages(page, groupId, pageId) async {
    print("innnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnm");
    if (isLoading) {
      return;
    }

    isLoading = true;
    var response = await getUserMessages(page, groupId, pageId);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadUserMessages(page, groupId, pageId);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return;
    } else if (response.statusCode == 200) {
     // if (type == "U") {}

      var responseBody = jsonDecode(response.body);
      print("////////////////////////////////////////");
      print(List<Map<String, dynamic>>.from(responseBody['messages']));
      List<Map<String, dynamic>> messagesData =
          List<Map<String, dynamic>>.from(responseBody['messages']);

// Create a list to store ChatMessage objects
      List<ChatMessage> chatMessages = [];

// Iterate through the messagesData and create ChatMessage objects
      for (var messageData in messagesData) {
        String text = messageData['text'];
        String senderUsername = messageData['senderUsername'];
        String receiverUsername = messageData['receiverUsername'];
        String? userPhoto = senderUsername != GetStorage().read("username")
            ? messageData['senderUsername_FK']['photo']
            : messageData['receiverUsername_FK']['photo'];

        ChatMessage chatMessage = ChatMessage(
          text: text?? '',
          isUser: senderUsername == GetStorage().read("username"),
          userName: senderUsername != GetStorage().read("username")
              ? messageData['senderUsername_FK']['username'] 
              : messageData['receiverUsername_FK']['username'],
          userPhoto: (userPhoto==null) ? '': userPhoto,
          createdAt: messageData['createdAt'],
          image: messageData['image'],
          video:messageData['video'],
        );

        messages.add(chatMessage);
      }
      
      isLoading = false;
    }

    return;
  }
}
