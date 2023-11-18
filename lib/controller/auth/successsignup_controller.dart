import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
abstract class SuccessSignUpController extends GetxController{

goToLogin();
}

class SuccessSignUpControllerImp extends SuccessSignUpController{

  
  @override
  goToLogin() {
    firstName="";
    lastName="";
    userName="";
    email="";
    password="";
    phone="";
    dateOfBirth="";
    code="";
 Get.offNamed(AppRoute.login);
  }

  

 
}