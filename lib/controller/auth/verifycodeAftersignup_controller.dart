import 'dart:convert';

import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
abstract class VerifyCodeAfterSignUpController extends GetxController{
checkCode();
goToSuccessSignUp();
postVerificationCode(verificationCode,email);
VerificationCode(verificationCode,email);
}

class VerifyCodeAfterSignUpControllerImp extends VerifyCodeAfterSignUpController{


late String verifycode;


  @override
  checkCode() {
    
  }
  
  @override
  goToSuccessSignUp() {
 Get.offNamed(AppRoute.SuccessSignUp);
  }
  @override
  Future postVerificationCode(verificationCode,email) async {
    var url = "$urlStarter/user/verification";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "verificationCode": verificationCode,
          "email": email,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    return responce;
  }
  @override
  VerificationCode(verificationCode,email) async {
    var res = await postVerificationCode(verificationCode,email);
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){
      Get.offNamed(AppRoute.SuccessSignUp);
    }
    
    //Get.offNamed(AppRoute.verifycodeaftersignup);
  }

  @override
  void onInit() {
  
    
    // TODO: implement onInit
    super.onInit();
  }

}