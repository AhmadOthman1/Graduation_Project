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

class ChatController extends GetxController {
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
  getUserMessages(int page, String username, String type) async {
    var url =
        "$urlStarter/user/getUserMessages?page=$page&pageSize=$pageSize&type=$type";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      'username': username,
    });
    return response;
  }

  Future<void> loadUserMessages(page, username, type,[String ? pageId]) async {
    print("innnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnm");
    if (isLoading) {
      return;
    }

    isLoading = true;
    var response = await getUserMessages(page, username, type);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadUserMessages(page, username, type,pageId);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return;
    } else if (response.statusCode == 200) {
      if (type == "U") {}

      var responseBody = jsonDecode(response.body);
      print("////////////////////////////////////////");
      print(List<Map<String, dynamic>>.from(responseBody['messages']));
      List<Map<String, dynamic>> messagesData =
          List<Map<String, dynamic>>.from(responseBody['messages']);

// Create a list to store ChatMessage objects
      List<ChatMessage> chatMessages = [];

// Iterate through the messagesData and create ChatMessage objects
      for (var messageData in messagesData) {
        print(messageData);
        print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
        String text = messageData['text'];
        String senderUsername = messageData['senderUsername'] ?? messageData['senderPageId'];
        String receiverUsername = messageData['receiverUsername'] ??  messageData['receiverPageId'] ;
        String? userPhoto = 
        type == "U" ?// if the conversation between user and other user
        senderUsername != GetStorage().read("username")?//get the other user/page photo
            messageData['senderUsername_FK']['photo'] 
            : messageData['receiverUsername_FK']['photo'] 
            ://if the conversation between page and other user get page photo
            messageData['senderPageId_FK'] != null ? messageData['senderPageId_FK']['photo']:messageData['receiverPageId_FK']['photo']
            
            ;

        // Create a ChatMessage object based on the conditions
        ChatMessage chatMessage = ChatMessage(
          text: text?? '',
          isUser: type=="U" ? 
          senderUsername == GetStorage().read("username") 
          : messageData['senderPageId_FK'] != null ? false: true,
          userName: type == "U" ?// if the conversation between user and other user
          senderUsername != GetStorage().read("username")? 
              messageData['senderUsername_FK']['username'] 
              : messageData['receiverUsername_FK']['username'] 
              :
              messageData['senderPageId_FK'] != null ? messageData['senderPageId_FK']['id']:messageData['receiverPageId_FK']['id']
            
              ,
          userPhoto: (userPhoto==null) ? '': userPhoto,
          createdAt: messageData['createdAt'],
          image: messageData['image'],
          video:messageData['video'],
        );

        // Add the ChatMessage object to the list
        messages.add(chatMessage);
      }
      /*messages.insert(
        0,
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );*/
      /*final List<dynamic>? userNotifications = responseBody["notifications"];
      print(userNotifications);
      print("userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      if (userNotifications != null) {
        final newNotifications = userNotifications.map((notification) {
          return {
            'id': notification['id'],
            'notificationType': notification['notificationType'],
            'notificationContent': notification['notificationContent'],
            'notificationPointer': notification['notificationPointer'],
            'photo': notification['photo'],
            'date': notification['createdAt'],
          };
        }).toList();

        notifications.addAll(newNotifications);
        //print(notifications);
      }*/

      isLoading = false;
    }

    /*
    await Future.delayed(const Duration(seconds: 2), () {
    });*/
    return;
  }
}
