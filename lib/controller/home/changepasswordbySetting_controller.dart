import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
abstract class ChangePasswordController extends GetxController{

postSaveChanges(_oldPassword,_newPassword);
SaveChanges(_oldPassword,_newPassword);
String? Email=GetStorage().read("loginemail") ;
}

class ChangePasswordControllerImp extends ChangePasswordController{



  final newPassword = ''.obs;
  final rewritePassword = ''.obs;
  final oldPassword = ''.obs;
  final obscureNewPassword = true.obs;
  final obscureRewritePassword = true.obs;
    final obscureOldPassword = true.obs;

  String? passwordsMatch(String? value) {
    if (value != null && value != newPassword.value) {
      return 'Passwords do not match';
    }
    return null;
  }

    void toggleOldPasswordVisibility() {
    obscureOldPassword.toggle();
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword.toggle();
  }

  void toggleRewritePasswordVisibility() {
    obscureRewritePassword.toggle();
  }
// here check if the old password correct , update the password by the new password

postSaveChanges(_oldPassword,_newPassword)async {
    var url = urlStarter + "/user/settingChangepasswor";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "email": Email,
          "oldPassword": _oldPassword,
          "newPassword": _newPassword,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    return responce;
  }
  @override
  SaveChanges(_oldPassword,_newPassword)async {
    try {
      var res = await postSaveChanges(_oldPassword,_newPassword);
      var resbody = jsonDecode(res.body);
      print(resbody['message']);
      print(res.statusCode);
      if(res.statusCode == 409 ||res.statusCode == 500  ){
        print(res.statusCode);
        return res.statusCode+":" + resbody['message'];
      }else if(res.statusCode == 200){
        print(res.statusCode);
        print(resbody['message']);
        resbody['message'] = "";
        GetStorage().write("loginpassword", _newPassword);
        Get.offNamed(AppRoute.homescreen);
      }

    } catch(err) {
      print(err);
      return "server error";
    }

 
  }


}