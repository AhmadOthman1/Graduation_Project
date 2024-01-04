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

class ShowColleaguesController {
  final List<Map<String, dynamic>> colleagues = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int pageSize = 10;
  int page = 1;

  getUserColleagues(int page) async {
    
    var url =
        "$urlStarter/user/getUserColleagues?page=$page&pageSize=$pageSize";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  Future<void> loadColleagues(page) async {
    if (isLoading) {
      return;
    }
    
    isLoading = true;
    var response = await getUserColleagues(page);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadColleagues(page);
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
      final List<dynamic>? userColleagues = responseBody["userConnections"];
      print(userColleagues);
      print("userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      if (userColleagues != null) {
        final newColleagues = userColleagues.map((colleague) {
          return {
            'username': colleague['connection']['username'],
            'firstname': colleague['connection']['firstname'],
            'lastname': colleague['connection']['lastname'],
            'photo': colleague['connection']['photo'],
          };
        }).toList();

        colleagues.addAll(newColleagues);
        
      }

      isLoading = false;
    }
    

    return;
  }


  
}
 




