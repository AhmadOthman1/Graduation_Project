import 'package:flutter/material.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/view/screen/auth/SignIn&SignUp/verifyCodeAfterSignUp.dart';
import 'package:growify/view/screen/auth/forgetpassword/forgetpassword.dart';
import 'package:growify/view/screen/auth/SignIn&SignUp/login.dart';
import 'package:growify/view/screen/auth/forgetpassword/resetpassword.dart';
import 'package:growify/view/screen/auth/SignIn&SignUp/signup.dart';
import 'package:growify/view/screen/auth/forgetpassword/success_resetPassword.dart';
import 'package:growify/view/screen/auth/SignIn&SignUp/success_signup.dart';
import 'package:growify/view/screen/auth/forgetpassword/verifycode.dart';
import 'package:growify/view/screen/homescreen/Networkspages/colleaguespage.dart';
import 'package:growify/view/screen/homescreen/Networkspages/groupspage.dart';
import 'package:growify/view/screen/homescreen/Networkspages/pagesfollow.dart';
import 'package:growify/view/screen/homescreen/Networkspages/peopleifollow.dart';
import 'package:growify/view/screen/homescreen/chat/chatmainpage.dart';
import 'package:growify/view/screen/homescreen/homeScreen.dart';
import 'package:growify/view/screen/homescreen/homepages/homemainPage.dart';
import 'package:growify/view/screen/homescreen/notificationspages/notificationmainpage.dart';


Map<String, Widget Function(BuildContext)>routes={
  //Auth
  AppRoute.login : (context)=>  Login(),
  AppRoute.signup : (context)=>  SignUp(),
  AppRoute.forgetpassword : (context)=> ForgetPassword(),
  AppRoute.verifycode : (context)=> const VerifyCode(),
  AppRoute.resetpassword : (context)=>  ResetPassword(),
  AppRoute.SuccessSignUp : (context)=> const SuccessSignUp(),
  AppRoute.SuccessResetPassword : (context)=> const SuccessResetPassword(),
  AppRoute.verifycodeaftersignup : (context)=> const VerifyCodeAfterSignUp(),
  AppRoute.homescreen : (context)=>  HomeScreen(),
  AppRoute.notificationspage : (context)=>  NotificationsPage(),
  AppRoute.colleaguespage : (context)=>  ColleaguesPage(),  
  AppRoute.groupspage : (context)=>  GroupsPage(), 
  AppRoute.pages : (context)=>  Pages(),
  AppRoute.peopleifollow : (context)=>  PeopleIFollow(),
  AppRoute.chatmainpage : (context)=>  ChatMainPage(),
   
};