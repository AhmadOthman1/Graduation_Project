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
String? pas;
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
                Obx(() => TextFormField(
                      obscureText: controller.obscureNewPassword.value,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Password',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        label: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 9),
                            child: Text("Password")),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureNewPassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              controller.toggleNewPasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (value) {
                        controller.newPassword.value = value;
                      },
                      validator: (value) {
                       return validInput(value!, 30, 8, "password");}
                    )),
                    SizedBox(height: 16),
                Obx(() => TextFormField(
                      obscureText:
                          controller.obscureRewritePassword.value,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Password',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        label: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 9),
                            child: Text("Password")),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureRewritePassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: controller
                              .toggleRewritePasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (value) {
                        controller.rewritePassword.value = value;
                      },
                      validator: (value){
                        pas=value;

                        return controller.passwordsMatch(value);

                      }
                    )),


              ButtonAuth(
                text: "Save",
                onPressed: () async {
                  if(formstate.currentState!.validate()){
                          print("Vaild");
                          var message = await controller.goToSuccessResetPassword(email,pas);
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
