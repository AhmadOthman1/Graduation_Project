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

class ShowAdminsController {
  final List<Map<String, dynamic>> admins = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int pageSize = 10;
  int page = 1;
final RxList<String> moreOptions = <String>[
    'Delete',
  ].obs;
onMoreOptionSelected(
      String option ,String adminUsername, String pageId) async {
      switch (option) {
        case 'Delete':
          return await deleteAdmin(pageId,adminUsername);
          break;
      }
  }
  deleteAdmin(pageId, adminUsername) async {
    var url = "$urlStarter/user/deleteAdmin";

    Map<String, dynamic> jsonData = {
      "pageId": pageId,
      "adminUsername": adminUsername,
    };
    String jsonString = jsonEncode(jsonData);
    var response = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      deleteAdmin(pageId, adminUsername);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    } else if( response.statusCode == 200){
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      admins.removeWhere((admin) => admin['username'] == adminUsername);
      return responseBody['message'];
      
    }
  }
  getPageAdmins(int page,String pageId) async {
    
    var url =
        "$urlStarter/user/getPageAdmins?page=$page&pageSize=$pageSize&pageId=$pageId";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  Future<void> loadAdmins(page,String pageId) async {
    if (isLoading) {
      return;
    }
    
    isLoading = true;
    var response = await getPageAdmins(page,pageId);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadAdmins(page,pageId);
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
      final List<dynamic>? pageAdmins = responseBody["pageAdmins"];
      print(pageAdmins);
      print(";;;;;;;;;;;;;;;;;;;;;");
      if (pageAdmins != null) {
        final admin = pageAdmins.map((pageAdmins) {
          return {
            'id': pageAdmins['id'],
            'pageId': pageAdmins['pageId'],
            'username': pageAdmins['username'],
            'firstname': pageAdmins['firstname'],
            'lastname': pageAdmins['lastname'],
            'adminType': pageAdmins['adminType'],
            'photo': pageAdmins['photo'],
            'date': pageAdmins['createdAt'],
          };
        }).toList();

        admins.addAll(admin);
        
      }

      isLoading = false;
    }
    

    return;
  }


  
}
 




