import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';

abstract class SuccessResetPasswordController extends GetxController{

goToLogin();
}

class SuccessResetPasswordControllerImp extends SuccessResetPasswordController{

  
  @override
  goToLogin() {
 Get.offNamed(AppRoute.login);
  }

  

 
}