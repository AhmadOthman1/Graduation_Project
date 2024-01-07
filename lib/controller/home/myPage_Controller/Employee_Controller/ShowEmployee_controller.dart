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

class ShowEmployeesController {
  final List<Map<String, dynamic>> employees = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int pageSize = 10;
  int page = 1;
final RxList<String> moreOptions = <String>[
    'Delete',
  ].obs;
onMoreOptionSelected(
      String option ,String employeeUsername, String pageId) async {
      switch (option) {
        case 'Delete':
          return await deleteEmployee(pageId,employeeUsername);
          break;
      }
  }
  deleteEmployee(pageId, employeeUsername) async {
    var url = "$urlStarter/user/deleteEmployee";

    Map<String, dynamic> jsonData = {
      "pageId": pageId,
      "employeeUsername": employeeUsername,
    };
    String jsonString = jsonEncode(jsonData);
    var response = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      deleteEmployee(pageId, employeeUsername);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    } else if( response.statusCode == 200){
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      employees.removeWhere((employee) => employee['username'] == employeeUsername);
      return responseBody['message'];
      
    }
  }
  getPageEmployees(int page,String pageId) async {
    
    var url =
        "$urlStarter/user/getPageEmployees?page=$page&pageSize=$pageSize&pageId=$pageId";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  Future<void> loadEmployees(page,String pageId) async {
    if (isLoading) {
      return;
    }
    
    isLoading = true;
    var response = await getPageEmployees(page,pageId);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadEmployees(page,pageId);
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
      final List<dynamic>? pageEmployees = responseBody["pageEmployees"];
      print(pageEmployees);
      print(";;;;;;;;;;;;;;;;;;;;;");
      if (pageEmployees != null) {
        final employee = pageEmployees.map((pageEmployees) {
           print(pageEmployees);
          return {
            'id': pageEmployees['id'],
            'pageId': pageEmployees['pageId'],
            'username': pageEmployees['username'],
            'firstname': pageEmployees['firstname'],
            'lastname': pageEmployees['lastname'],
            'employeeField': pageEmployees['field'],
            'photo': pageEmployees['photo'],
            'date': pageEmployees['createdAt'],
          };
          
        }).toList();

        employees.addAll(employee);
       
      }

      isLoading = false;
    }
    

    return;
  }


  
}
 




