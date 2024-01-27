import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
abstract class ResetPasswordController extends GetxController{

goToSuccessResetPassword(email,password,code);
postChangePassword(email,password,code);
}

class ResetPasswordControllerImp extends ResetPasswordController{


  /*late TextEditingController password;
  late TextEditingController repassword;

    bool isshowpass=true;

  showPassord(){
    isshowpass=isshowpass==true?false:true;
    update();
  }

  @override
  resetpassword() {
    
  }*/

  final newPassword = ''.obs;
  final rewritePassword = ''.obs;
  final obscureNewPassword = true.obs;
  final obscureRewritePassword = true.obs;

  String? passwordsMatch(String? value) {
    if (value != null && value != newPassword.value) {
      return 'Passwords do not match';
    }
    return null;
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword.toggle();
  }

  void toggleRewritePasswordVisibility() {
    obscureRewritePassword.toggle();
  }

     @override
  Future postChangePassword(email,password,code) async {
    var ipAddress = IpAddress(type: RequestType.text);
    dynamic ip = await ipAddress.getIpAddress();
    var url = "$urlStarter/user/changepassword";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "email": email.trim(),
          "password": password.trim(),
          "code":code,
          "ipAddress": ip,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    return responce;
  }

  @override
  goToSuccessResetPassword(email,password,code)async {
    var res = await postChangePassword(email,password,code);
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){
      Get.offNamed(AppRoute.SuccessResetPassword);
    }
    
  }

 //Get.offNamed(AppRoute.SuccessResetPassword);
  
/*
  @override
  void onInit() {
    password=TextEditingController();
    repassword=TextEditingController();
    
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {

    password.dispose();
    repassword.dispose();
 
    super.dispose();
  }*/

}