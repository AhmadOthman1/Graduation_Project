import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

abstract class LoginController extends GetxController {
  login(email, password);
  goToSignup();
  goToForgetPassword();
  postLogin(email, password);
}

class LoginControllerImp extends LoginController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController email;
  late TextEditingController password;

  bool isshowpass = true;

  showPassord() {
    isshowpass = isshowpass == true ? false : true;
    update();
  }

  LoginControllerImp() {
    // Initialize formstate in the constructor.
    formstate = GlobalKey<FormState>();
  }
  Future postLogin(email, password) async {
    var url = urlStarter + "/user/Login";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "email": email.trim(),
          "password": password.trim(),
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    return responce;
  }

  @override
  login(email, password) async {
    // Check if formstate.currentState is not null before using it.
    try {
      var res = await postLogin(email, password);
      var resbody = jsonDecode(res.body);
      print(resbody['message']);
      print(res.statusCode);
      if (res.statusCode == 409) {
        return resbody['message'];
      } else if (res.statusCode == 200 && resbody['message'] == "logged") {
        resbody['message'] = "";
        GetStorage().write("loginemail", email);
        GetStorage().write("loginpassword", password);
        Get.offNamed(AppRoute.homescreen);
      }
    } catch (err) {
      print(err);
      return "server error";
    }
  }

  @override
  goToSignup() {
    Get.offNamed(AppRoute.signup);
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  goToForgetPassword() {
    Get.offNamed(AppRoute.forgetpassword);
  }
}
