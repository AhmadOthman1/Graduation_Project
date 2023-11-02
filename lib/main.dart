import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/routes.dart';
import 'package:growify/view/screen/auth/SignIn&SignUp/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home:const Login(),
      
      routes: routes,
    );
  }
}
