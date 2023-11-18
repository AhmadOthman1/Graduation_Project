import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/auth/login_controller.dart';
import 'package:growify/core/constant/imagesAssets.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/core/functions/alertexitapp.dart';
import 'package:growify/core/functions/validinput.dart';
import 'package:growify/view/widget/auth/ButtonAuth.dart';
import 'package:growify/view/widget/auth/logoAuth.dart';

import 'package:growify/view/widget/auth/textBodyAuth.dart';
import 'package:growify/view/widget/auth/textFormAuth.dart';
import 'package:growify/view/widget/auth/textSignupORsignIn.dart';
import 'package:growify/view/widget/auth/textTitleAuth.dart';
import 'package:growify/global.dart';
class Login extends StatelessWidget {
   Login({super.key}){
    firstName="";
    lastName="";
    userName="";
    email="";
    password="";
    phone="";
    dateOfBirth="";
    code="";
   }

  GlobalKey<FormState>formstate=GlobalKey();

  @override
  Widget build(BuildContext context) {
    LoginControllerImp controller = Get.put(LoginControllerImp());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white38,
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            "Sign In",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        body: WillPopScope(
          onWillPop: alertExitApp,
            child: Container(
             // key: controller.formstate,
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              child: Form(
                key: formstate,
                child: ListView(
                  children: [
                    LogoAuth(),
                const    SizedBox(
                      height: 30,
                    ),
               const     TextTitleAuth(
                      text: "Welcome Back",
                    ),
              const      SizedBox(
                      height: 25,
                    ),
                const    TextBodyAuth(
                        text:
                            "Sign In With Your Email And Password OR \n\n Continue With Social Media"),
              const      SizedBox(
                      height: 40,
                    ),
                    TextFormAuth(
                      
                      valid: (value) {
                        email = value;
                        return validInput(value!, 100, 2, "email");
                        
                      },
                      mycontroller: controller.email,
                      hinttext: "Enter Your Email",
                      labeltext: "Email",
                      iconData: Icons.email_outlined,
                    ),
                    GetBuilder<LoginControllerImp>(builder: (controller)=>TextFormAuth(
                      onTapIcon: (){
                        controller.showPassord();
                      },
                      obscureText: controller.isshowpass,
                      valid: (value) {
                        password = value;
                        return validInput(value!, 30, 8, "password");
                      },
                      mycontroller: controller.password,
                      hinttext: "Enter Your Password",
                      labeltext: "Password",
                      iconData: Icons.lock_outlined,
                    ),),
                const    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        controller.goToForgetPassword();
                      },
                      child: const Text(
                        "Forget Password",
                        textAlign: TextAlign.end,
                      ),
                    ),
                    ButtonAuth(
                      text: "Sign In",
                      onPressed: () async {
                       
                       if(formstate.currentState!.validate()){
                        print("Vaild");
                        var message = await controller.login(email , password);
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
                    ),
                const    SizedBox(
                      height: 30,
                    ),
                    SignUporSignIn(
                      textOne: "Don't have an account ? ",
                      textTwo: "Sign Up",
                      onTap: () {
                        controller.goToSignup();
                      },
                    ),
                  ],
                ),
              ),
            ),
            ));
  }
}
