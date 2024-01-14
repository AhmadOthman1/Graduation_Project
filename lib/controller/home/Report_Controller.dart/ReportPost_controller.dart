


import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());




class ReportPostController extends GetxController {



reportThePost(postId,text) async {
  var url = "$urlStarter/user/createPostReport";

    Map<String, dynamic> jsonData = {
      "postId": postId,
      "text": text,
      
    };
    String jsonString = jsonEncode(jsonData);
    var response = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      reportThePost(postId,text);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    } else if( response.statusCode == 200){
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return responseBody['message'];
      
    }else{
      var responseBody = jsonDecode(response.body);
      return responseBody['message'];
    }
}
  




  
  




  
}