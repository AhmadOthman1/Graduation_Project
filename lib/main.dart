import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/routes.dart';
import 'package:growify/view/screen/auth/SignIn&SignUp/login.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/homeScreen.dart';
void main() async{

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
    String? Email=GetStorage().read("loginemail") ;
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
     textTheme: const TextTheme(
      headline1:  TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
               
      bodyText1: TextStyle(fontSize: 14, color: Colors.grey),


     ),
      ),
      debugShowCheckedModeBanner: false,
      home:(Email==null)?Login():HomeScreen(),
      
      routes: routes,
    );
  }
}
