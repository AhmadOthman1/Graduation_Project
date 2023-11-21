import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
abstract class ChangePasswordController extends GetxController{


SaveChanges(_oldPassword,_newPassword);
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
  SaveChanges(_oldPassword,_newPassword){
  Get.toNamed(AppRoute.login);
}



}