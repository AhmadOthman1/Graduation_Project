import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

getMyPageInfo(pageId) async {
  var url = urlStarter +
      "/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
  var responce = await http.get(Uri.parse(url), headers: {
    'Content-type': 'application/json; charset=UTF-8',
    'Authorization': 'bearer ' + GetStorage().read('accessToken'),
  });
  print(responce);
  return responce;
}

goToMyPageInfo(pageId) async {
  var res = await getMyPageInfo(pageId);
  if (res.statusCode == 403) {
    await getRefreshToken(GetStorage().read('refreshToken'));
    goToMyPageInfo(pageId);
    return;
  } else if (res.statusCode == 401) {
    _logoutController.goTosigninpage();
  }
  var resbody = jsonDecode(res.body);
  if (res.statusCode == 409) {
    return resbody['message'];
  } else if (res.statusCode == 200) {
    //Get.to(ProfileSettings(userData: [resbody["user"]]));
  }
}

class PageDetailsController extends GetxController {}
