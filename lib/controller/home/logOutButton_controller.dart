import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

abstract class LogOutButtonController extends GetxController {
  goTosigninpage();
}

class LogOutButtonControllerImp extends GetxController {
  postLogOut(accessToken) async {
    var url = "$urlStarter/user/LogOut";
    var responce = await http.post(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + accessToken,
    });
    return responce;
  }

  goTosigninpage() async {
    // GetStorage().write("loginemail", "");
    // GetStorage().write("loginpassword", "");
    GetStorage().remove('loginemail');
    GetStorage().remove('loginpassword');
    var refreshToken= GetStorage().read("refreshToken");
    var accessToken= GetStorage().read("accessToken");
    GetStorage().remove('refreshToken');
    GetStorage().remove('accessToken');
    firstName = "";
    lastName = "";
    userName = "";
    email = "";
    password = "";
    phone = "";
    dateOfBirth = "";
    code = "";
    try {
      var res = await postLogOut(accessToken);
      if (res.statusCode == 403) {
        await getRefreshToken(refreshToken);
        await goTosigninpage();
        return null;
      } else if (res.statusCode == 401) {
        Get.toNamed(AppRoute.login);
      }
      if (res.statusCode == 409 || res.statusCode == 500) {
      } else if (res.statusCode == 200) {
        Get.toNamed(AppRoute.login);
      }
    } catch (err) {
      print(err);
      return "server error";
    }

    Get.toNamed(AppRoute.login);
  }
}
