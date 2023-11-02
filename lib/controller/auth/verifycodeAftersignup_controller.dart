import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';

abstract class VerifyCodeAfterSignUpController extends GetxController{
checkCode();
goToSuccessSignUp();
}

class VerifyCodeAfterSignUpControllerImp extends VerifyCodeAfterSignUpController{

late String verifycode;
  @override
  checkCode() {
    
  }
  
  @override
  goToSuccessSignUp() {
 Get.offNamed(AppRoute.SuccessSignUp);
  }

  @override
  void onInit() {
  
    
    // TODO: implement onInit
    super.onInit();
  }

}