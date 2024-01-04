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

class ShowRequestsReceivedController {
  final List<Map<String, dynamic>> requestsReceived = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int pageSize = 10;
  int page = 1;

  getUserRequestsReceived(int page) async {
    
    var url =
        "$urlStarter/user/getUserRequestsReceived?page=$page&pageSize=$pageSize";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  Future<void> loadRequestsReceived(page) async {
    if (isLoading) {
      return;
    }
    print(page);
    isLoading = true;
    var response = await getUserRequestsReceived(page);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadRequestsReceived(page);
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
      final List<dynamic>? userRequestsReceived = responseBody["userConnectionsRequestsReceived"];
      print(userRequestsReceived);
      print("userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      if (userRequestsReceived != null) {
        final newColleagues = userRequestsReceived.map((Request) {
          return {
            'username': Request['senderUser']['username'],
            'firstname': Request['senderUser']['firstname'],
            'lastname': Request['senderUser']['lastname'],
            'photo': Request['senderUser']['photo'],
          };
        }).toList();

        requestsReceived.addAll(newColleagues);
        
      }

      isLoading = false;
    }
    

    return;
  }




  
}
