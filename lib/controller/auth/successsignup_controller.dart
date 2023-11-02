import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';

abstract class SuccessSignUpController extends GetxController{

goToLogin();
}

class SuccessSignUpControllerImp extends SuccessSignUpController{

  
  @override
  goToLogin() {
 Get.offNamed(AppRoute.login);
  }

  

 
}