import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:http/http.dart' as http;
import 'package:growify/controller/home/logOutButton_controller.dart';

var urlStarter = "http://192.168.235.173:3000";
var urlSSEStarter = "http://192.168.235.173:4000";
dynamic incomingSDPOffer;
//flutter run -d emulator-5556
String? firstName;
String? lastName;
String? userName;
String? email;
String? password;
String? phone;
String? dateOfBirth;
String? code;
LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());
getRefreshToken(refreshToken) async {
  var url = "$urlStarter/user/token";
  var responce = await http.post(Uri.parse(url), headers: {
    'Content-type': 'application/json; charset=UTF-8',
    'Authorization': 'bearer ' + refreshToken ?? "",
  });
  print(responce.statusCode);
  if (responce.statusCode == 401) {
    print("heeeeeeeeeeeeeeeeeeeeeeee");
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
  } else if (responce.statusCode == 403) {
    await getRefreshToken(GetStorage().read('refreshToken'));
    return;
  } else {
    var resbody = jsonDecode(responce.body);
    GetStorage().write('accessToken', resbody['accessToken']);
    return;
  }
}
