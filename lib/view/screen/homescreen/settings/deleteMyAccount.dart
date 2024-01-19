import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/deleteMyAccount_controller/deleteAccount_Controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/core/functions/validinput.dart';
import 'package:growify/view/widget/auth/ButtonAuth.dart';
import 'package:growify/view/widget/auth/textTitleAuth.dart';

class DeleteAccount extends StatelessWidget {
  DeleteAccount({super.key});
  GlobalKey<FormState> formstate = GlobalKey();
  String? _password;


  @override
  Widget build(BuildContext context) {
    DeleteAccountControllerImp controller = Get.put(DeleteAccountControllerImp());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Delete Account",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
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
                text: "Delete My Account",
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
                        child: const Text("Password")),
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
              const SizedBox(height: 16),
             
              ButtonAuth(
                text: "Confirmation",
                onPressed: () async {
                  //Get.to(VerifyCodeEmailChange());
                  if (formstate.currentState!.validate()) {
                    var message = await controller.Confirmation(_password);
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
