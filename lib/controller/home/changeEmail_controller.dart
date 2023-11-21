import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

abstract class ChangeEmailController extends GetxController {}

class ChangeEmailControllerImp extends ChangeEmailController {
  late TextEditingController email;

  final yourPassword = ''.obs;

  final obscureyourPassword = true.obs;

  void toggleYourPasswordVisibility() {
    obscureyourPassword.toggle();
  }

  @override
  void onInit() {

    email = TextEditingController();

    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {

    email.dispose();

    // TODO: implement dispose
    super.dispose();
  }
}
