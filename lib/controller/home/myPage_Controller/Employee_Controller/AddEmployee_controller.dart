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

class AddEmployeeController {
  final List<Map<String, dynamic>> employees = [];
  final ScrollController scrollController = ScrollController();

  addEmployee(pageId, employeeUsername,field) async {
    var url = "$urlStarter/user/addNewEmployee";
    Map<String, dynamic> jsonData = {
      "pageId": pageId,
      "employeeUsername": employeeUsername,
      "field": field,
    };
    String jsonString = jsonEncode(jsonData);
    var response = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      addEmployee(pageId, employeeUsername,field);
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
