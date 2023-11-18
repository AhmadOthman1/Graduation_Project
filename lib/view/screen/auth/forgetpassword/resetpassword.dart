import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/auth/resetpassword_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/core/functions/validinput.dart';
import 'package:growify/global.dart';
import 'package:growify/view/widget/auth/ButtonAuth.dart';
import 'package:growify/view/widget/auth/textFormAuth.dart';
import 'package:growify/view/widget/auth/textTitleAuth.dart';

class ResetPassword extends StatelessWidget {
   ResetPassword({super.key});
GlobalKey<FormState>formstate=GlobalKey();
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
        child: Form(
          key: formstate,
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
                  valid: (value) {
                    password=value;
                    return validInput(value!, 30, 8, "password");
                  },
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
                  valid: (value) {
                    password=value;
                    return validInput(value!, 30, 8, "password");
                  },
                  mycontroller: controller.password,
                  hinttext: "Enter Your Password",
                  labeltext: "Password",
                  iconData: Icons.lock_outlined,
                ),
              ),
              ButtonAuth(
                text: "Save",
                onPressed: () async {
                  if(formstate.currentState!.validate()){
                          print("Vaild");
                          var message = await controller.goToSuccessResetPassword(email,password);
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
            ],
          ),
        ),
      ),
    );
  }
}
