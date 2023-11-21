import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
abstract class ChangePasswordController extends GetxController{

//goToSuccessResetPassword(email,password);
//postChangePassword(email,password);
goTosigninpage();
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

  goTosigninpage(){
  Get.toNamed(AppRoute.login);
}
/*
     Future postChangePassword(email,password) async {
    var url = urlStarter + "/user/changepassword";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "email": email.trim(),
          "password": password.trim(),

        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    return responce;
  }

  @override
  goToSuccessResetPassword(email,password)async {
    var res = await postChangePassword(email,password);
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){
      Get.offNamed(AppRoute.SuccessResetPassword);
    }
    
  }*/


}