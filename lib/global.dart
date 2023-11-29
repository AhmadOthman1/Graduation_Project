<<<<<<< HEAD
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:growify/controller/home/logOutButton_controller.dart';
var urlStarter= "http://192.168.59.173:3000";
=======
var urlStarter= "http://192.168.88.11:3000";
>>>>>>> 727850a2be4eadc4dbb8a2804d6fd9697d609a23
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? password;
  String? phone;
  String? dateOfBirth;
  String? code;
  LogOutButtonControllerImp _logoutController = Get.put(LogOutButtonControllerImp());
  getRefreshToken(refreshToken) async {
    var url = urlStarter + "/user/token";
    var responce = await http.post(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + refreshToken?? "",
        });
        if(responce.statusCode==401 ||responce.statusCode==403 ){
          _logoutController.goTosigninpage();
        }
        else{
          var resbody = jsonDecode(responce.body);
          GetStorage().write('accessToken',resbody['accessToken'] );
        }
        
  }