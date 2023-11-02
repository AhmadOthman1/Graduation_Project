import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';

abstract class ForgetPasswordController extends GetxController{
checkemail();
goToVerfiycode();
}

class ForgetPasswordControllerImp extends ForgetPasswordController{


  late TextEditingController email;

  @override
  checkemail() {
    
  }
  
  @override
  goToVerfiycode() {
 Get.offNamed(AppRoute.verifycode);
  }

  @override
  void onInit() {
    email=TextEditingController();
    
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {

    email.dispose();
 
    super.dispose();
  }

}