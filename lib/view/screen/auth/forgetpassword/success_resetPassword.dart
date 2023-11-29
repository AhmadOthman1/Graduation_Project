import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/auth/successResetpassword_controller.dart';
import 'package:growify/view/widget/auth/ButtonAuth.dart';

class SuccessResetPassword extends StatelessWidget {
  const SuccessResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    SuccessResetPasswordControllerImp controller=Get.put(SuccessResetPasswordControllerImp());
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
        padding:const EdgeInsets.all(15),
        child: Column(
          children: [
          const  Center(child: Icon(Icons.check_circle_outline,size: 200,color:Color.fromARGB(255, 85, 191, 218),)),
            const Text("Go to ..."),
            
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
            const SizedBox(height: 30,)

            
          ],
        ),
      )
    );
  }
}