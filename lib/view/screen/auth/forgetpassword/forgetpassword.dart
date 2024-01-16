import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/auth/forgetPassword_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/core/functions/validinput.dart';
import 'package:growify/global.dart';
import 'package:growify/view/widget/auth/ButtonAuth.dart';
import 'package:growify/view/widget/auth/textBodyAuth.dart';
import 'package:growify/view/widget/auth/textFormAuth.dart';
import 'package:growify/view/widget/auth/textTitleAuth.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  GlobalKey<FormState> formstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ForgetPasswordControllerImp controller =
        Get.put(ForgetPasswordControllerImp());
    if (kIsWeb) {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
          child: Form(
            key: formstate,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
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
                          valid: (value) {
                            email = value;
                            return validInput(value!, 100, 2, "email");
                          },
                          mycontroller: controller.email,
                          hinttext: "Enter Your Email",
                          labeltext: "Email",
                          iconData: Icons.email_outlined,
                        ),
                        ButtonAuth(
                          text: "Confirm",
                          onPressed: () async {
                            if (formstate.currentState!.validate()) {
                              var message =
                                  await controller.goToVerfiycode(email);
                              (message != null)
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomAlertDialog(
                                          title: 'Error',
                                          icon: Icons.error,
                                          text: message,
                                          buttonText: 'OK',
                                        );
                                      },
                                    )
                                  : null;
                            } else {
                              print("Not Valid");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('images/forgotpassword.png'),
                        width: 500,
                        height: 500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
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
          child: Form(
            key: formstate,
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
                  valid: (value) {
                    email = value;
                    return validInput(value!, 100, 2, "email");
                  },
                  mycontroller: controller.email,
                  hinttext: "Enter Your Email",
                  labeltext: "Email",
                  iconData: Icons.email_outlined,
                ),
                ButtonAuth(
                  text: "Confirm",
                  onPressed: () async {
                    if (formstate.currentState!.validate()) {
                      var message = await controller.goToVerfiycode(email);
                      (message != null)
                          ? showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomAlertDialog(
                                  title: 'Error',
                                  icon: Icons.error,
                                  text: message,
                                  buttonText: 'OK',
                                );
                              },
                            )
                          : null;
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
}
