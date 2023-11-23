import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/settings/verfiycode_emailchange.dart';
import 'package:http/http.dart' as http;

abstract class ChangeEmailController extends GetxController {
  SaveChanges(newEmail,password);
  postSaveChanges(newEmail,password);
}

class ChangeEmailControllerImp extends ChangeEmailController {
  late TextEditingController email;

  final yourPassword = ''.obs;
  String Email = GetStorage().read("loginemail");
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
  // here chould you check if password correct , update the email
  postSaveChanges(newEmail,password)async {
    var url = urlStarter + "/user/settingChangeemail";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "email": Email,
          "newEmail": newEmail.trim(),
          "Password": password.toString(),
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    return responce;
  }
  @override
  SaveChanges(newEmail,password) async {
    try {
      var res = await postSaveChanges(newEmail,password);
      var resbody = jsonDecode(res.body);
      print(resbody['message']);
      print(res.statusCode);
      if(res.statusCode == 409 ||res.statusCode == 500  ){
        print(res.statusCode);
        return resbody['message'];
      }else if(res.statusCode == 200){
        resbody['message'] = "";
        //GetStorage().write("loginemail", _newEmail);
        Get.to( VerifyCodeEmailChange(newEmail: newEmail));
      }

    } catch(err) {
      print(err);
      return "server error";
    }


  }
}