import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());


class ShowMembersController {
  final RxList<String> moreOptions = <String>[
    'Delete',
  ].obs;
  onMoreOptionSelected(option, employeeUsername, groupId) async {
    switch (option) {
      case 'Delete':
        return await deleteMember(groupId, employeeUsername);
        break;
    }
  }

  deleteMember(groupId, employeeUsername) async {
    var url = "$urlStarter/user/deleteGroupMember";

    Map<String, dynamic> jsonData = {
      "employeeUsername": employeeUsername,
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
      deleteMember(groupId, employeeUsername);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    } else if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      members.removeWhere((member) => member['username'] == employeeUsername);
      return responseBody['message'];
    } else {
      var responseBody = jsonDecode(response.body);
      return responseBody['message'];
    }
  }

  //////////////
  final List<Map<String, dynamic>> members = [];
  final AssetImage defaultProfileImage =
      const AssetImage("images/profileImage.jpg");
}
