import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/notificationspages/showPost.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class NotificationsController {
  final List<Map<String, dynamic>> notifications = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int pageSize = 10;
  int page = 1;

  getUserNotifications(int page) async {
    
    var url =
        "$urlStarter/user/getUserNotifications?page=$page&pageSize=$pageSize";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  Future<void> loadNotifications(page) async {
    if (isLoading) {
      return;
    }
    
    isLoading = true;
    var response = await getUserNotifications(page);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadNotifications(page);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return;
    } else if (response.statusCode == 200) {
      
      
      var responseBody = jsonDecode(response.body);
      final List<dynamic>? userNotifications = responseBody["notifications"];
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
      }

      isLoading = false;
    }
    
    /*
    await Future.delayed(const Duration(seconds: 2), () {
    });*/
    return;
  }

  showPost(){

    
    Get.to(() => const ShowPost());

  }

  
}
