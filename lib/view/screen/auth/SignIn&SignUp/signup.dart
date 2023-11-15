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
                  return validInput(value!, 20, 5, "username");
                },
                mycontroller:controller.username ,
                hinttext: "Enter Your Username",
                labeltext: "Username",
                iconData: Icons.person_outlined,
              ),
        
            
               TextFormAuth(
                valid: (value){
                  return validInput(value!, 20, 12, "email");
                },
                mycontroller: controller.email,
                hinttext: "Enter Your Email",
                labeltext: "Email",
                iconData: Icons.email_outlined,
              ),
        
                TextFormAuth(
                  valid: (value){
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
                          return validInput(value!, 30, 8, "password");
                        },
                        mycontroller: controller.password,
                        hinttext: "Enter Your Password",
                        labeltext: "Password",
                        iconData: Icons.lock_outlined,
                      ),),
              
              ButtonAuth(
                text: "Sign Up",
                onPressed: () {
                  controller.signup();
                /* if(formstate.currentState!.validate()){
                        print("Vaild");
                       
                       }else{
                        print("Not Valid");
                       }*/
                },
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
