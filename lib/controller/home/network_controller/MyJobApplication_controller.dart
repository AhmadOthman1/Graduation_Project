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

class MyJobApplicationController {
  final List<Map<String, dynamic>> jobs = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int pageSize = 10;
  int page = 1;

  getJobs(page) async {
    
    var url =
        "$urlStarter/user/getUserApplications?page=$page&pageSize=$pageSize";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  Future<void> loadJobs(page) async {
    if (isLoading) {
      return;
    }
    
    isLoading = true;
    var response = await getJobs(page);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadJobs(page);
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
      print("ccccccccccccccccccccccccccccc");
      print(response.body);
      final List<dynamic>? pageJobs = responseBody["pages"];
      print(pageJobs);
      print("userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrokkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
      if (pageJobs != null) {
        final newJob = pageJobs.map((job) {
          return {
            'pageJobId': job['pageJobId'].toString(),
            'pageId': job['pageId'],
            'title': job['title'],
            'Fields': job['Fields'],
            'description': job['description'],
            'note': job['note'],
          };
        }).toList();

        jobs.addAll(newJob);
        //print(notifications);
      }

      isLoading = false;
    }
    
    /*
    await Future.delayed(const Duration(seconds: 2), () {
    });*/
    return;
  }


  
}
