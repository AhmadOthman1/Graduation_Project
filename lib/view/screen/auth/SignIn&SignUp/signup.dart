import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/auth/signup_controller.dart';
import 'package:growify/core/constant/imagesAssets.dart';
import 'package:growify/core/functions/alertexitapp.dart';
import 'package:growify/view/widget/auth/ButtonAuth.dart';
import 'package:growify/view/widget/auth/logoAuth.dart';

import 'package:growify/view/widget/auth/textBodyAuth.dart';
import 'package:growify/view/widget/auth/textFormAuth.dart';
import 'package:growify/view/widget/auth/textSignupORsignIn.dart';
import 'package:growify/view/widget/auth/textTitleAuth.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
              valid: (value){},
              mycontroller:controller.username ,
              hinttext: "Enter Your Username",
              labeltext: "Username",
              iconData: Icons.person_outlined,
            ),

          
             TextFormAuth(
              valid: (value){},
              mycontroller: controller.email,
              hinttext: "Enter Your Email",
              labeltext: "Email",
              iconData: Icons.email_outlined,
            ),

              TextFormAuth(
                valid: (value){},
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
    ));
  }
}
