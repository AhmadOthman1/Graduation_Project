import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/ColleaguesPageProfile.dart';
import 'package:growify/view/screen/homescreen/settings/Profilesettings.dart';
import 'package:growify/view/screen/homescreen/settings/theEducation.dart';
import 'package:growify/view/screen/homescreen/settings/workexperience.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

abstract class SettingsController extends GetxController {
  getWorkExperiencePgae();
  goToWorkExperiencePgae();
  goToProfileSettingsPgae();
  getProfileSettingsPgae();
  getEducationLevel();
  goToEducationLevel();
}

class SettingsControllerImp extends SettingsController {
  @override
  Future getProfileSettingsPgae() async {
    var url = "$urlStarter/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
    var accessToken = GetStorage().read('accessToken') ?? "";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + accessToken,
    });
    print(responce);
    return responce;
  }

  @override
  goToProfileSettingsPgae() async {
    var res = await getProfileSettingsPgae();
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToProfileSettingsPgae();
      return;
    } else if (res.statusCode == 401) {
            print("2222222222222222222222222");

      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      GetStorage().write("photo", resbody["user"]["photo"]);
      Get.to(ProfileSettings(userData: [resbody["user"]]));
    }
  }

  @override
  Future getWorkExperiencePgae() async {
    var url = "$urlStarter/user/getworkExperience?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  @override
  goToWorkExperiencePgae() async {
    var res = await getWorkExperiencePgae();
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToWorkExperiencePgae();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409 || res.statusCode == 500) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      var responseBody = jsonDecode(res.body);
      var workExperiences = (responseBody['workExperiences'] as List<dynamic>)
          .map((dynamic experience) =>
              Map<String, String>.from(experience as Map<String, dynamic>))
          .toList();
      Get.to(
         WorkExperience(),
        arguments: {'workExperiences': workExperiences},
      );
    }
  }

  @override
  getEducationLevel() async {
    var url = "$urlStarter/user/getEducationLevel?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  @override
  goToEducationLevel() async {
    var res = await getEducationLevel();
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToEducationLevel();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409 || res.statusCode == 500) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      var responseBody = jsonDecode(res.body);
      var EducationLevel = (responseBody['educationLevel'] as List<dynamic>)
          .map((dynamic experience) =>
              Map<String, String>.from(experience as Map<String, dynamic>))
          .toList();
      Get.to(
         Education(),
        arguments: {'educationLevel': EducationLevel},
      );
    }
  }
   final List<Map<String, dynamic>> userData = [
    {
      "firstname": "Al Hamas",
      "photo": null,
      "coverImage": null,
      "Description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    }
  ];


   final List<Map<String, dynamic>> userData1 = [
    {
      "username": "Al Hamas",
      "firstname":"mojj",
      "lastname":"lastname",
      "bio":null,
      "country":null,
      "address":null,
      "phone":"0569929734",
      "dateOfBirth":"2001-05-18",
      "photo": null,
      "coverImage": null,
      "cv":null,
      "connection": "12"
    }
  ];

  goToColleaguesPageProfile(){
    Get.to(ColleaguesPageProfile(userData:userData));
  }


 
}
