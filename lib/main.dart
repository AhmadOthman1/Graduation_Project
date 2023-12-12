import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/routes.dart';
import 'package:growify/view/screen/auth/SignIn&SignUp/login.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/homeScreen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:growify/services/notification_service.dart';
void main() async{
  await NotificationService.initializeNotification();

  firstName="";
  lastName="";
  userName="";
  email="";
  password="";
  phone="";
   dateOfBirth="";
   code="";
   await GetStorage.init();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
    String? accessToken=GetStorage().read("accessToken") ;
    static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(accessToken);
    print("llllllllllllllllllllllllllllllllllllll");
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
     textTheme: const TextTheme(
      displayLarge:  TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
               
      bodyLarge: TextStyle(fontSize: 14, color: Colors.grey),


     ),
      ),
      debugShowCheckedModeBanner: false,
      home:( accessToken==null || accessToken=="")?Login():const HomeScreen(),
      
      routes: routes,
    );
  }
}
