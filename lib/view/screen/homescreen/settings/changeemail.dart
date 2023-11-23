import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/changeEmail_controller.dart';
import 'package:growify/core/functions/validinput.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/settings/verfiycode_emailchange.dart';
import 'package:growify/view/widget/auth/ButtonAuth.dart';
import 'package:growify/view/widget/auth/textFormAuth.dart';
import 'package:growify/view/widget/auth/textTitleAuth.dart';

class ChangeEmail extends StatelessWidget {
  ChangeEmail({super.key});
  GlobalKey<FormState> formstate = GlobalKey();
  String? _password;
  String?_newEmail;

  @override
  Widget build(BuildContext context) {
    ChangeEmailControllerImp controller = Get.put(ChangeEmailControllerImp());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Email",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
        child: Form(
          key: formstate,
          child: ListView(
            children: [
              const TextTitleAuth(
                text: "New Email",
              ),
              const SizedBox(
                height: 60,
              ),
              Obx(() => TextFormField(
                  obscureText: controller.obscureyourPassword.value,
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
                        controller.obscureyourPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: controller.toggleYourPasswordVisibility,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onChanged: (value) {
                    controller.yourPassword.value = value;
                  },
                  validator: (value) {
                    _password=value;
                    return validInput(value!, 30, 8, "password");
                  })),
              SizedBox(height: 16),
              TextFormAuth(
                valid: (value) {
                  _newEmail = value;
                  return validInput(value!, 100, 12, "email");
                },
                mycontroller: controller.email,
                hinttext: "Enter Your Email",
                labeltext: "Email",
                iconData: Icons.email_outlined,
              ),
              ButtonAuth(
                text: "Save",
                onPressed: () async {
                  Get.to(VerifyCodeEmailChange());
                  if (formstate.currentState!.validate()) {
                    controller.SaveChanges(_newEmail,_password);
                    
                    print("Vaild");
                  } else {
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
