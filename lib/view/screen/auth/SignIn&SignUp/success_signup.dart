import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/auth/successsignup_controller.dart';
import 'package:growify/view/widget/auth/ButtonAuth.dart';

class SuccessSignUp extends StatelessWidget {
  const SuccessSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    SuccessSignUpControllerImp controller =
        Get.put(SuccessSignUpControllerImp());
    if (kIsWeb) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white38,
            elevation: 0.0,
            centerTitle: true,
            title: const Text(
              "Success",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          body: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                        children: [
                          const Center(
                              child: Icon(
                            Icons.check_circle_outline,
                            size: 200,
                            color: Color.fromARGB(255, 85, 191, 218),
                          )),
                          const SizedBox(
                            height: 100,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ButtonAuth(
                              text: "Go To Login",
                              onPressed: () {
                                controller.goToLogin();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                ],
              ),
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white38,
            elevation: 0.0,
            centerTitle: true,
            title: const Text(
              "Success",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Center(
                    child: Icon(
                  Icons.check_circle_outline,
                  size: 200,
                  color: Color.fromARGB(255, 85, 191, 218),
                )),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ButtonAuth(
                    text: "Go To Login",
                    onPressed: () {
                      controller.goToLogin();
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ));
    }
  }
}
