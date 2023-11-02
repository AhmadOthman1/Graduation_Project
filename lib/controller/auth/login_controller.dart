import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';

abstract class LoginController extends GetxController{
login();
goToSignup();
goToForgetPassword();
}

class LoginControllerImp extends LoginController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController email;
  late TextEditingController password;

  bool isshowpass=true;

  showPassord(){
    isshowpass=isshowpass==true?false:true;
    update();
  }

  LoginControllerImp() {
    // Initialize formstate in the constructor.
    formstate = GlobalKey<FormState>();
  }

  @override
  login() {
    // Check if formstate.currentState is not null before using it.
   /*  if (formstate.currentState != null && formstate.currentState!.validate()) {
      print("Valid");
    } else {
      print("Not Valid");
    }*/
    Get.offNamed(AppRoute.homescreen);


  }

  @override
  goToSignup() {
    Get.offNamed(AppRoute.signup);
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  goToForgetPassword() {
    Get.offNamed(AppRoute.forgetpassword);
  }
}
