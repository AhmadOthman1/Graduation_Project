import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';

abstract class ResetPasswordController extends GetxController{
resetpassword();
goToSuccessResetPassword();
}

class ResetPasswordControllerImp extends ResetPasswordController{


  late TextEditingController password;
  late TextEditingController repassword;

    bool isshowpass=true;

  showPassord(){
    isshowpass=isshowpass==true?false:true;
    update();
  }

  @override
  resetpassword() {
    
  }
  
  @override
  goToSuccessResetPassword() {
 Get.offNamed(AppRoute.SuccessResetPassword);
  }

  @override
  void onInit() {
    password=TextEditingController();
    repassword=TextEditingController();
    
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {

    password.dispose();
    repassword.dispose();
 
    super.dispose();
  }

}