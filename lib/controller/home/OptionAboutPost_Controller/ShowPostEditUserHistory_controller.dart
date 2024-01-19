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

class ShowEditUserController {
  final List<Map<String, dynamic>> EditPosthistory = [];
  final ScrollController scrollController = ScrollController();

  Future<void> getPostEditHistory(int postId) async {
    var url = "$urlStarter/user/getPostHistory";
    
    Map<String, dynamic> jsonData = {
      "postId": postId,
    };
    
    String jsonString = jsonEncode(jsonData);
    
    try {
      var response = await http.post(Uri.parse(url), body: jsonString, headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      });

      print("My Lovvve");
      print(response.statusCode);

      if (response.statusCode == 403) {
        await getRefreshToken(GetStorage().read('refreshToken'));
        getPostEditHistory(postId);
        return;
      } else if (response.statusCode == 401) {
        _logoutController.goTosigninpage();
        return;
      }

      if (response.statusCode == 409) {
        var responseBody = jsonDecode(response.body);

   
        return;
      } else if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        final List<dynamic>? meetingsHistory = responseBody["PostHistory"];

        print("User 1111111");
        print(responseBody);
        print("User 11111111");

        if (meetingsHistory != null) {
          final newMeetingsHistory = meetingsHistory.map((history) {
            return {
              'PreviousText': history['PreviousText'],
              'updatedAt': history['updatedAt'],
            };
          }).toList();

          EditPosthistory.addAll(newMeetingsHistory);
          print("OOoopopopopopopopopopopopop");
          print(EditPosthistory);
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
