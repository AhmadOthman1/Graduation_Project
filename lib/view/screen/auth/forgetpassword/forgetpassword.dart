import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/auth/forgetPassword_controller.dart';
import 'package:growify/view/widget/auth/ButtonAuth.dart';
import 'package:growify/view/widget/auth/textBodyAuth.dart';
import 'package:growify/view/widget/auth/textFormAuth.dart';
import 'package:growify/view/widget/auth/textTitleAuth.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    ForgetPasswordControllerImp controller=Get.put(ForgetPasswordControllerImp());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white38,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Forget Password",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
        child: ListView(
          children: [
         
            const TextTitleAuth(
              text: "Forgot Your Password? ",
            ),
            const SizedBox(
              height: 20,
            ),
            const TextBodyAuth(
                text:
                    "Enter Your Email We Will Sent You\n\n A Verification Code"),
            const SizedBox(
              height: 60,
            ),

          
          
             TextFormAuth(
              valid: (value){},
              mycontroller: controller.email,
              hinttext: "Enter Your Email",
              labeltext: "Email",
              iconData: Icons.email_outlined,
            ),



          
            ButtonAuth(
              text: "Confirm",
              onPressed: () {
                controller.goToVerfiycode();
              },
            ),
           
          ],
        ),
      ),
    );
  }
}
