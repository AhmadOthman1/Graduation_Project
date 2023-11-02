import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';

abstract class SignUpController extends GetxController{
signup();
goToSignIn();
}

class SignUpControllerImp extends SignUpController{

  late TextEditingController username;
  late TextEditingController phone;
  late TextEditingController email;
  late TextEditingController password;

  bool isshowpass=true;

  showPassord(){
    isshowpass=isshowpass==true?false:true;
    update();
  }



  @override
  signup() {
    Get.offNamed(AppRoute.verifycodeaftersignup);
  }
  
  @override
  goToSignIn() {
 Get.offNamed(AppRoute.login);
  }

  @override
  void onInit() {
    username=TextEditingController();
    phone=TextEditingController();
    email=TextEditingController();
    password=TextEditingController();
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    username.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
    // TODO: implement dispose
    super.dispose();
  }

}