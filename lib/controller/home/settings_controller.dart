import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/settings/Profilesettings.dart';
import 'package:growify/view/screen/homescreen/settings/theEducation.dart';
import 'package:growify/view/screen/homescreen/settings/workexperience.dart';
import 'package:http/http.dart' as http;
abstract class SettingsController extends GetxController {


getWorkExperiencePgae();
goToWorkExperiencePgae();
goToProfileSettingsPgae();
getProfileSettingsPgae();
getEducationLevel();
 goToEducationLevel();
}

class SettingsControllerImp extends SettingsController {

Future getProfileSettingsPgae() async {
    var url = urlStarter + "/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
  print(responce);
    return responce;
  }
goToProfileSettingsPgae() async {
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
 

  }
   Future getWorkExperiencePgae() async {
    var url = urlStarter + "/user/getworkExperience?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    print(responce);
    return responce;
  }
  goToWorkExperiencePgae()async{
    var res = await getWorkExperiencePgae();
    var resbody = jsonDecode(res.body);
    if(res.statusCode == 409 || res.statusCode == 500){
      return resbody['message'];
    }else if(res.statusCode == 200){
    var responseBody = jsonDecode(res.body);
    print(responseBody);
    var workExperiences = (responseBody['workExperiences'] as List<dynamic>)
        .map((dynamic experience) =>
            Map<String, String>.from(experience as Map<String, dynamic>))
        .toList();
    print(workExperiences);
    Get.to(
        WorkExperience(),
        arguments: {'workExperiences': workExperiences},
      );
      
    } 
  }

getEducationLevel() async {
var url = urlStarter + "/user/getEducationLevel?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    print(responce);
    return responce;
}
  goToEducationLevel() async {
    var res = await getEducationLevel();
    var resbody = jsonDecode(res.body);
    if(res.statusCode == 409 || res.statusCode == 500){
      return resbody['message'];
    }else if(res.statusCode == 200){
    var responseBody = jsonDecode(res.body);
    print(responseBody);
    var EducationLevel = (responseBody['educationLevel'] as List<dynamic>)
        .map((dynamic experience) =>
            Map<String, String>.from(experience as Map<String, dynamic>))
        .toList();
    print(EducationLevel);
    Get.to(
        Education(),
        arguments: {'educationLevel': EducationLevel},
      );
      
    } 

   
  }
  

}
