import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/settings/Profilesettings.dart';
import 'package:http/http.dart' as http;
abstract class SettingsController extends GetxController {

    // put data from database here
  static const String Firstname = 'Obaida';
  static const String Lastname = 'Aws';
  static const String Address = 'Aqraba';
  static const String Country = 'Palestine';
  static const String DateOfBirth = '2001-05-25';
  static const String Phone = '0594376261';
  static const String Bio = 'I will be the best wherever I am';
  String? Email=GetStorage().read("loginemail") ;
  final List<Map<String, dynamic>> userData = const [
    {
      "name": Firstname,
      "lastname": Lastname,
      "address": Address,
      "country": Country,
      "dateOfBirth": DateOfBirth,
      "phone": Phone,
      "bio": Bio,
    },
  ];

goToProfileSettingsPgae();
getProfileSettingsPgae();

}

class SettingsControllerImp extends SettingsController {

Future getProfileSettingsPgae() async {
    var url = urlStarter + "/user/settingsGetMainInfo?email=$Email";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });

    return responce;
  }
goToProfileSettingsPgae() async {
 // Get.toNamed(AppRoute.profilesetting);
 var res = await getProfileSettingsPgae();
    /*var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){
      Get.offNamed(AppRoute.verifycodeaftersignup);
    } */
    print("====================*");
 Get.to(ProfileSettings(userData: userData));


}
}
