import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/auth/forgetpassword/resetpassword.dart';
import 'package:http/http.dart' as http;

abstract class VerifyCodeController extends GetxController {
  checkCode();
  goToResetPassword(verificationCode, email);
  postVerificationCode(verificationCode, email);
}

class VerifyCodeControllerImp extends VerifyCodeController {
  late String verifycode;
  @override
  checkCode() {}
  @override
  Future postVerificationCode(verificationCode, email) async {
    var ipAddress = IpAddress(type: RequestType.text);
    dynamic ip = await ipAddress.getIpAddress();

    var url = "$urlStarter/user/forgetpasswordverification";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "verificationCode": verificationCode,
          "email": email,
          "ipAddress": ip,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    return responce;
  }

  @override
  goToResetPassword(verificationCode, email) async {
    var res = await postVerificationCode(verificationCode, email);
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      Get.off(ResetPassword(code: verificationCode));
    }

    //Get.offNamed(AppRoute.verifycodeaftersignup);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
