import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/view/screen/homescreen/notificationspages/notificationmainpage.dart';

abstract class HomePageController extends GetxController{
login();
goToSignup();
goToForgetPassword();
goToProfilePage();
toggleConnectButton();
}

class HomePageControllerImp extends HomePageController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController email;
  late TextEditingController password;
  var isConnectButtonPressed = false.obs;

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
    if (formstate.currentState != null && formstate.currentState!.validate()) {
      print("Valid");
    } else {
      print("Not Valid");
    }
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
  
  @override
  goToProfilePage() {
    
  }
  
  @override
  toggleConnectButton() {
    isConnectButtonPressed.value = !isConnectButtonPressed.value;
    update();
    
  }
}
