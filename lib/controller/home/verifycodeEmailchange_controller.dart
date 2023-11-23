import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
import 'package:growify/global.dart';
abstract class VerifyCodeEmailChangeController extends GetxController{


postVerificationCode(verificationCode,newEmail);
VerificationCode(verificationCode,newEmail);
}

class VerifyCodeEmailChangeControllerImp extends VerifyCodeEmailChangeController{


late String verifycode;


  

  Future postVerificationCode(verificationCode,newEmail) async {
    print(newEmail+"ffffff");
   var url = urlStarter + "/user/settingChangeemailVerificationCode";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "verificationCode": verificationCode,
          "email": newEmail,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    return responce;
  }
  VerificationCode(verificationCode,newEmail) async {
    var res = await postVerificationCode(verificationCode,newEmail);
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    if(res.statusCode == 409 || res.statusCode == 500){
      return resbody['message'];
    }else if(res.statusCode == 200){
      Get.offNamed(AppRoute.settings);
    }
    
    //Get.offNamed(AppRoute.verifycodeaftersignup);
  }

  @override
  void onInit() {
  
    
    // TODO: implement onInit
    super.onInit();
  }

}