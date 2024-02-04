


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class GroupSettingsController extends GetxController {

  deleteGroup(groupId) async {
    var url = "$urlStarter/user/deleteGroup";

    Map<String, dynamic> jsonData = {
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
      deleteGroup(groupId);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    } else if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return responseBody['message'];
    } else {
      var responseBody = jsonDecode(response.body);
      return responseBody['message'];
    }

    
  }


  // Admin leave Groups


Future<String?> adminLeaveGroup(groupId,context) async {
  print("kkkkkkkkkkkkkkkk");
  print(groupId);

  var url = "$urlStarter/user/leavePageGroup";

  Map<String, dynamic> jsonData = {
    "groupId": groupId,
  };
  String jsonString = jsonEncode(jsonData);
  var response = await http.post(Uri.parse(url), body: jsonString, headers: {
    'Content-type': 'application/json; charset=UTF-8',
    'Authorization': 'bearer ' + GetStorage().read('accessToken'),
  });

  print(response.statusCode);

  var responseBody = jsonDecode(response.body);
  print(responseBody['message']);

  if (response.statusCode == 403) {
    await getRefreshToken(GetStorage().read('refreshToken'));
    return adminLeaveGroup(groupId,context);
  } else if (response.statusCode == 401) {
    _logoutController.goTosigninpage();
  } 
  else if(response.statusCode == 200){
     showDialog(
      context: context,  // Make sure you have access to the context
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Admin Leave Group"),
          content: Text(responseBody['message']),
          actions: [
            TextButton(
              onPressed: () {
                Get.offNamed(AppRoute.homescreen);
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
   
  }
  else {
    // Show message in a dialog
    showDialog(
      context: context,  // Make sure you have access to the context
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Admin Leave Group"),
          content: Text(responseBody['message']),
          actions: [
            TextButton(
              onPressed: () {
                // You can add any additional actions if needed
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

   

    return responseBody['message'];
  }
}



}