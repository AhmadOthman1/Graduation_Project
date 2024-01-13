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

class AddMembersController {
  final List<Map<String, dynamic>> admins = [];
  final ScrollController scrollController = ScrollController();

  addMember(MemberUsername,groupId) async {
    var url = "$urlStarter/user/addGroupMember";
    var SR;
   
    Map<String, dynamic> jsonData = {
      "isEmployee": "false",
      "memberUsername": MemberUsername,
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
      addMember( MemberUsername,groupId);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    } else {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return responseBody['message'];
    }
  }
}
