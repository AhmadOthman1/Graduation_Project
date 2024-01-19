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

class ShowMeetingHistoryController {
  final List<Map<String, dynamic>> meetinghistory = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int pageSize = 10;
  int page = 1;

  getMeetingsHistory(int page,int groupId) async {
    
    var url =
        "$urlStarter/user/meetingHistory?groupId=$groupId&page=$page&pageSize=$pageSize";
        print(url);
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  Future<void> loadMeetingsHistory(page,groupId) async {
    if (isLoading) {
      return;
    }
    
    isLoading = true;
    var response = await getMeetingsHistory(page,groupId);
  
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadMeetingsHistory(page,groupId);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(groupId);
      print("Hissssssssssssstoooory");
      print(responseBody['message']);
       print("Hissssssssssssstoooory");
      return;
    } else if (response.statusCode == 200) {
      
      
      var responseBody = jsonDecode(response.body);
      final List<dynamic>? meetingsHistory = responseBody["meetings"];
       print("userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr1111111");
      print(responseBody);
      print("userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr11111111");
      if (meetingsHistory != null) {
        final newMeetingsHistory = meetingsHistory.map((history) {
          return {
            'meetingId': history['meetingId'],
            'period': history['period'],
            'startedAt':history['startedAt'],

          };
        }).toList();

        meetinghistory.addAll(newMeetingsHistory);
        
      }

      isLoading = false;
    }
    

    return;
  }


  
}
 




