import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/settings/verfiycode_emailchange.dart';
import 'package:http/http.dart' as http;
LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

abstract class DeleteAccountController extends GetxController {
  Confirmation(password);
  postSaveChanges(password);
}

class DeleteAccountControllerImp extends DeleteAccountController {


  final yourPassword = ''.obs;
  final obscureyourPassword = true.obs;

  void toggleYourPasswordVisibility() {
    obscureyourPassword.toggle();
  }

 
  // here chould you check if password correct , update the email
  @override
  postSaveChanges(password)async {
    var url = "$urlStarter/user/deleteUserAccount";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
         
          "password": password.toString(),
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),
        });
    return responce;
  }
  @override
  Confirmation(password) async {
    try {
      var res = await postSaveChanges(password);
      if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      postSaveChanges(password);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
      var resbody = jsonDecode(res.body);
      print(resbody['message']);
      print(res.statusCode);
      if(res.statusCode == 409 ||res.statusCode == 500  ){
        print(res.statusCode);
        return resbody['message'];
      }else if(res.statusCode == 200){
        resbody['message'] = "";
       
       _logoutController.goTosigninpage();
      }

    } catch(err) {
      print(err);
      return "server error";
    }


  }
}
