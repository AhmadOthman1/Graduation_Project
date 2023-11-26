import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/myPages_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/notificationspages/notificationmainpage.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:http/http.dart' as http;

abstract class HomePageController extends GetxController{
login();
goToSignup();
goToForgetPassword();
goToProfileColleaguesPage();
toggleConnectButton();
goToSettingsPgae();
goToprofilepage();
getprfilepage();
getprfileColleaguespage();
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

  goToSettingsPgae(){
  Get.toNamed(AppRoute.settings);
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
  toggleConnectButton() {
    isConnectButtonPressed.value = !isConnectButtonPressed.value;
    update();
    
  }

  ///////////////////////////////////////////////////////
   
  Future getprfilepage() async{
        var url = urlStarter + "/user/settingsGetMainInfo?email=$Email";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
  print(responce);
    return responce;

  }
  
  
  @override
  goToprofilepage() async{

     var res = await getprfilepage();
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    print(resbody);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){
     // Get.to(ProfileMainPage(), arguments: {'user': resbody["user"]});


      Get.to(ProfileMainPage(userData: [resbody["user"]]));
    } 
 


   // Get.to(ProfileMainPage());

  }
  @override

   Future getprfileColleaguespage() async{
        var url = urlStarter + "/user/settingsGetMainInfo?email=$Email";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
  print(responce);
    return responce;

  }

  

  

    @override
  goToProfileColleaguesPage()async {
         var res = await getprfileColleaguespage();
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    print(resbody);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){


    Get.to(ColleaguesProfile(userData: [resbody["user"]]));
  }
  
 
}}
