import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/auth/signup_controller.dart';
import 'package:growify/core/constant/imagesAssets.dart';
import 'package:growify/core/functions/alertexitapp.dart';
import 'package:growify/core/functions/validinput.dart';
import 'package:growify/view/widget/auth/ButtonAuth.dart';
import 'package:growify/view/widget/auth/logoAuth.dart';

import 'package:growify/view/widget/auth/textBodyAuth.dart';
import 'package:growify/view/widget/auth/textFormAuth.dart';
import 'package:growify/view/widget/auth/textSignupORsignIn.dart';
import 'package:growify/view/widget/auth/textTitleAuth.dart';
import 'package:http/http.dart' as http;
import 'package:growify/global.dart';
import 'package:growify/core/functions/alertbox.dart';
class SignUp extends StatelessWidget {
   SignUp({super.key});
  GlobalKey<FormState>formstate=GlobalKey();



 
  @override
  Widget build(BuildContext context) {
    SignUpControllerImp controller=Get.put(SignUpControllerImp());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white38,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
      body: WillPopScope(
          onWillPop: alertExitApp,
            child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
        child: Form(
          key: formstate,
          child: ListView(
            children: [
           
              const TextTitleAuth(
                text: "Welcome Back",
              ),
              const SizedBox(
                height: 20,
              ),
              const TextBodyAuth(
                  text:
                      "Sign Up  OR  Continue With Social Media"),
              const SizedBox(
                height: 60,
              ),
               TextFormAuth(
                
                valid: (value){
                  firstName= value;
                  return validInput(value!, 50, 1, "username");
                },
                mycontroller:controller.username ,
                hinttext: "Enter Your first name",
                labeltext: "First name",
                iconData: Icons.person_outlined,
              ),
               TextFormAuth(
                
                valid: (value){
                  lastName= value;
                  return validInput(value!, 50, 1, "username");
                },
                mycontroller:controller.username ,
                hinttext: "Enter Your last name",
                labeltext: "Lastname",
                iconData: Icons.person_outlined,
              ),
               TextFormAuth(
                
                valid: (value){
                  userName= value;
                  return validInput(value!, 50, 5, "username");
                },
                mycontroller:controller.username ,
                hinttext: "Enter Your Username",
                labeltext: "Username",
                iconData: Icons.person_outlined,
              ),
        
            
               TextFormAuth(
                valid: (value){
                  email= value;
                  return validInput(value!, 100, 12, "email");
                },
                mycontroller: controller.email,
                hinttext: "Enter Your Email",
                labeltext: "Email",
                iconData: Icons.email_outlined,
              ),
        
                TextFormAuth(
                  valid: (value){
                    phone=value;
                    return validInput(value!, 15, 10, "phone");
                  },
                mycontroller: controller.phone,
                hinttext: "Enter Your Phone",
                labeltext: "Phone",
                iconData: Icons.phone_android_outlined,
              ),
        
        
        
              GetBuilder<SignUpControllerImp>(builder: (controller)=>TextFormAuth(
                onTapIcon: (){
                  controller.showPassord();
                },
                obscureText: controller.isshowpass,
                valid: (value) {
                  password=value;
                  return validInput(value!, 30, 8, "password");
                },
                mycontroller: controller.password,
                hinttext: "Enter Your Password",
                labeltext: "Password",
                iconData: Icons.lock_outlined,
              ),),
              TextFormAuth(
                valid: (value){
                  dateOfBirth=value;
                  return validInput(value!, 10, 8, "dateOfBirth");
                },
                mycontroller: controller.dateOfBirth,
                hinttext: "Enter Your date of birth",
                labeltext: "date of birth",
                iconData: Icons.event,
              ),
              
              ButtonAuth(
                text: "Sign Up",
                onPressed: () async {
                    // Call the asynchronous function within an async context
                    if(formstate.currentState!.validate()){
                        print("Vaild");
                        var message = await controller.signup(firstName,lastName,userName,email,password,phone,dateOfBirth);
                        (message != null) ? showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              title: 'Error',
                              icon: Icons.error,
                              text: message,
                              buttonText: 'OK',
                            );
                          },
                        ) : null ;
                       
                       }else{
                        print("Not Valid");
                       }
                      
                  },
                /*onPressed: () {
                 // var res = postSignin();
                  controller.signup();
                /* if(formstate.currentState!.validate()){
                        print("Vaild");
                       
                       }else{
                        print("Not Valid");
                       }*/
                },*/
              ),
              const SizedBox(
                height: 30,
              ),
            SignUporSignIn(
                textOne: "Have an account ? ",
                textTwo: "Sign In",
                onTap: () {
                  controller.goToSignIn();
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
