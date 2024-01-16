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

    var refreshToken = GetStorage().read("refreshToken");
    var accessToken = GetStorage().read("accessToken");
    try {
      var res = await postLogOut(accessToken);
      if (res.statusCode == 403) {
        await getRefreshToken(refreshToken);
        await goTosigninpage();
        return null;
      } else if (res.statusCode == 401) {
        GetStorage().remove('loginemail');
        GetStorage().remove('loginpassword');
        GetStorage().remove('refreshToken');
        GetStorage().remove('accessToken');
        GetStorage().remove('username');
        GetStorage().remove('firstname');
        GetStorage().remove('lastname');
        GetStorage().remove('photo');
        firstName = "";
        lastName = "";
        userName = "";
        email = "";
        password = "";
        phone = "";
        dateOfBirth = "";
        code = "";
        Get.toNamed(AppRoute.login);
      }
      if (res.statusCode == 409 || res.statusCode == 500) {
      } else if (res.statusCode == 200) {
        var url2 = '$urlSSEStarter/userNotifications/notifications';
        var responce = await http.get(Uri.parse(url2), headers: {
          'Authorization': 'bearer ' + accessToken,
          "Accept": "text/event-stream",
          "Cache-Control": "no-cache",
          "isClosed": "true",
        });
        print(responce.statusCode);
        if (responce.statusCode == 403) {
          await getRefreshToken(refreshToken);
          await goTosigninpage();
          return null;
        } else if (responce.statusCode == 401) {
          GetStorage().remove('loginemail');
          GetStorage().remove('loginpassword');
          GetStorage().remove('refreshToken');
          GetStorage().remove('accessToken');
          GetStorage().remove('username');
          GetStorage().remove('firstname');
          GetStorage().remove('lastname');
          GetStorage().remove('photo');
          firstName = "";
          lastName = "";
          userName = "";
          email = "";
          password = "";
          phone = "";
          dateOfBirth = "";
          code = "";
          Get.toNamed(AppRoute.login);
        }
        if (responce.statusCode == 200) {
          print(";;;;;;;;;;;;;;;;;;;;;;;;;");
          GetStorage().remove('loginemail');
          GetStorage().remove('loginpassword');
          GetStorage().remove('refreshToken');
          GetStorage().remove('accessToken');
          GetStorage().remove('username');
          GetStorage().remove('firstname');
          GetStorage().remove('lastname');
          GetStorage().remove('photo');
          firstName = "";
          lastName = "";
          userName = "";
          email = "";
          password = "";
          phone = "";
          dateOfBirth = "";
          code = "";
          Get.toNamed(AppRoute.login);
        }
      }
    } catch (err) {
      print(err);
      return "server error";
    }
    GetStorage().remove('loginemail');
    GetStorage().remove('loginpassword');
    GetStorage().remove('refreshToken');
    GetStorage().remove('accessToken');
    GetStorage().remove('username');
    GetStorage().remove('firstname');
    GetStorage().remove('lastname');
    GetStorage().remove('photo');
    firstName = "";
    lastName = "";
    userName = "";
    email = "";
    password = "";
    phone = "";
    dateOfBirth = "";
    code = "";
    Get.offNamed(AppRoute.login);
  }
}
