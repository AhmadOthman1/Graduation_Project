import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/auth/resetpassword_controller.dart';
import 'package:growify/view/widget/auth/ButtonAuth.dart';
import 'package:growify/view/widget/auth/textFormAuth.dart';
import 'package:growify/view/widget/auth/textTitleAuth.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    ResetPasswordControllerImp controller =
        Get.put(ResetPasswordControllerImp());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white38,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
        child: ListView(
          children: [
            const TextTitleAuth(
              text: "New Password",
            ),
            const SizedBox(
              height: 60,
            ),
            GetBuilder<ResetPasswordControllerImp>(
              builder: (controller) => TextFormAuth(
                onTapIcon: () {
                  controller.showPassord();
                },
                obscureText: controller.isshowpass,
                valid: (value) {},
                mycontroller: controller.password,
                hinttext: "Enter Your Password",
                labeltext: "Password",
                iconData: Icons.lock_outlined,
              ),
            ),
               GetBuilder<ResetPasswordControllerImp>(
              builder: (controller) => TextFormAuth(
                onTapIcon: () {
                  controller.showPassord();
                },
                obscureText: controller.isshowpass,
                valid: (value) {},
                mycontroller: controller.password,
                hinttext: "Enter Your Password",
                labeltext: "Password",
                iconData: Icons.lock_outlined,
              ),
            ),
            ButtonAuth(
              text: "Save",
              onPressed: () {
                controller.goToSuccessResetPassword();
              },
            ),
          ],
        ),
      ),
    );
  }
}
