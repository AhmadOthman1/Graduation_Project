import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/settings/Profilesettings.dart';
import 'package:http/http.dart' as http;
abstract class SettingsController extends GetxController {

    // put data from database here

  String? Email=GetStorage().read("loginemail") ;
  

goToProfileSettingsPgae();
getProfileSettingsPgae();

}

class SettingsControllerImp extends SettingsController {

Future getProfileSettingsPgae() async {
    print("///////////////////////////////");
    var url = urlStarter + "/user/settingsGetMainInfo?email=$Email";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
  print(responce);
    return responce;
  }
goToProfileSettingsPgae() async {
 // Get.toNamed(AppRoute.profilesetting);
 var res = await getProfileSettingsPgae();
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    print(resbody);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){

      Get.to(ProfileSettings(userData: [resbody["user"]]));
    } 
    print("====================*");
 


}
}
