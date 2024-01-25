import 'dart:convert';
import 'dart:math';

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

   
        messages.insert(0, chatMessage);
        
  }




  var _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  createMeeting(groupId) async {
    var meetingId = GetStorage().read('username')  + groupId.toString();
    var url = "$urlStarter/user/createGroupMeeting";
    Map<String, dynamic> jsonData = {
      "meetingId": meetingId,
      "groupId": groupId,
    };
    String jsonString = jsonEncode(jsonData);
    var response = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      createMeeting(groupId);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }else if(response.statusCode == 406){
      return createMeeting(groupId);
    }
     else {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return meetingId;
    }
  }

joinMeeting(meetingId, groupId) async {
    var url = "$urlStarter/user/joinGroupMeeting";
    Map<String, dynamic> jsonData = {
      "meetingId": meetingId,
      "groupId": groupId,
    };
    String jsonString = jsonEncode(jsonData);
    var response = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      joinMeeting(meetingId, groupId) ;
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
     else {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return responseBody['message'];
    }
  
}


  getUserMessages(int page, int groupId) async {
    var url =
        "$urlStarter/user/getMyPageGroupMessages?groupId=$groupId&page=$page&pageSize=$pageSize";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      
    });
    print("Hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
    print(response);
    return response;
  }

  // Modify your loadUserMessages function
Future<void> loadUserMessages(page, groupId) async {
  print("innnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnm");
  if (isLoading) {
    return;
  }

  isLoading = true;
  var response = await getUserMessages(page, groupId);
  print(response.statusCode);
  if (response.statusCode == 403) {
    await getRefreshToken(GetStorage().read('refreshToken'));
    loadUserMessages(page, groupId);
    return;
  } else if (response.statusCode == 401) {
    _logoutController.goTosigninpage();
  }

  if (response.statusCode == 409) {
    var responseBody = jsonDecode(response.body);
    print("Awssssssssssssssssssss");
    print(responseBody['message']);
    return;
  } else if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);
    print(responseBody);

    // Assuming 'groupMessages' is the key for the list of messages
    List<Map<String, dynamic>> messagesData =
        List<Map<String, dynamic>>.from(responseBody['groupMessages']);

    // Create a list to store ChatMessage objects
    List<ChatMessage> chatMessages = [];

    for (var messageData in messagesData) {
      String text = messageData['text'];
      String senderUsername = messageData['senderUsername'];
      // Check the actual structure of your response for 'receiverUsername' and 'createdAt'
      // Adjust these lines accordingly
      String receiverUsername = messageData['receiverUsername'] ?? '';
      String createdAt = messageData['createdAt'] ?? '';
      String? userPhoto = senderUsername != GetStorage().read("username")
          ? messageData['user']['photo']
          : '';

      ChatMessage chatMessage = ChatMessage(
        text: text ?? '',
        isUser: senderUsername == GetStorage().read("username"),
        userName: senderUsername != GetStorage().read("username")
            ? messageData['user']['username']
            : receiverUsername,
        userPhoto: userPhoto ?? '',
        createdAt: createdAt,
        image: messageData['image'],
        video: messageData['video'],
      );

      messages.add(chatMessage);
    }

    isLoading = false;
  }

  return;
}

}
