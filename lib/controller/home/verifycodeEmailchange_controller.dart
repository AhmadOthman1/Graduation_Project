import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
abstract class VerifyCodeEmailChangeController extends GetxController{


postVerificationCode(verificationCode,newEmail);
VerificationCode(verificationCode,newEmail);
}
LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());
class VerifyCodeEmailChangeControllerImp extends VerifyCodeEmailChangeController{


late String verifyCode;


  

  @override
  Future postVerificationCode(verificationCode,newEmail) async {
        var ipAddress = IpAddress(type: RequestType.text);
    dynamic ip = await ipAddress.getIpAddress();

    print(newEmail+"ffffff");
   var url = "$urlStarter/user/settingChangeemailVerificationCode";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "verificationCode": verificationCode,
          "email": newEmail,
          "ipAddress":ip,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),
        });
    return responce;
  }
  @override
  VerificationCode(verificationCode,newEmail) async {
    var res = await postVerificationCode(verificationCode,newEmail);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
       VerificationCode(verificationCode,newEmail);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    if(res.statusCode == 409 || res.statusCode == 500){
      return resbody['message'];
    }else if(res.statusCode == 200){
      _logoutController.goTosigninpage();
    }
    
    //Get.offNamed(AppRoute.verifycodeaftersignup);
  }

  @override
  void onInit() {
  
    
    // TODO: implement onInit
    super.onInit();
  }

}