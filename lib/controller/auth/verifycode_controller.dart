import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';

abstract class VerifyCodeController extends GetxController{
checkCode();
goToResetPassword();
}

class VerifyCodeControllerImp extends VerifyCodeController{

late String verifycode;
  @override
  checkCode() {
    
  }
  
  @override
  goToResetPassword() {
 Get.offNamed(AppRoute.resetpassword);
  }

  @override
  void onInit() {
  
    
    // TODO: implement onInit
    super.onInit();
  }

}