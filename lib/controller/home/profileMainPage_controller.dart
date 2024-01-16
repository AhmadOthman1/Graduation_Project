import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/profilepages/seeAboutinfo.dart';
import 'package:http/http.dart' as http;
LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class ProfileMainPageControllerImp extends GetxController {
  // get data from database
  final RxMap personalDetails = {}.obs;

  final RxList<Map<String, String>> educationLevels =
      <Map<String, String>>[].obs;

  final RxList<Map<String, String>> practicalExperiences =
      <Map<String, String>>[].obs;
// for profile
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;

  // for cover page
  // for cover image
  final RxString coverImageBytes = ''.obs;
  final RxString coverImageBytesName = ''.obs;
  final RxString coverImageExt = ''.obs;



 getProfileSettingsPgae() async {
    var url = "$urlStarter/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),

        });
  print(responce);
    return responce;
  }
goToProfileMainInfo() async {
 var res = await getProfileSettingsPgae();
 if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToProfileMainInfo();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){
      if (resbody['user'] is Map<String, dynamic>) {
      // If the 'user' field is a Map, assign it to personalDetails
      personalDetails.assignAll(resbody['user']);
      print(personalDetails);
      return true;
    }
    } 
 

  }
  getEducationLevel() async {
    var url = "$urlStarter/user/getEducationLevel?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

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
      print(responseBody);
      var EducationLevel = (responseBody['educationLevel'] as List<dynamic>)
          .map((dynamic experience) =>
              Map<String, String>.from(experience as Map<String, dynamic>))
          .toList();
      print(EducationLevel);
      educationLevels.assignAll(EducationLevel);
      return true;
    }
  }

  Future getWorkExperiencePgae() async {
    var url = "$urlStarter/user/getworkExperience?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

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
      print(responseBody);
      var workExperiences = (responseBody['workExperiences'] as List<dynamic>)
          .map((dynamic experience) =>
              Map<String, String>.from(experience as Map<String, dynamic>))
          .toList();
      print(workExperiences);
      practicalExperiences.assignAll(workExperiences);
      return true;
    }
  }

  goToAboutInfo() async {
    var WorkExperienceInfo = await goToWorkExperiencePgae();
    var EducationLevelInfo = await goToEducationLevel();
    var ProfileMainInfo = await goToProfileMainInfo();
    if (WorkExperienceInfo!= null && EducationLevelInfo!=null && ProfileMainInfo!=null) {
      Get.to(
        SeeAboutInfo(),
        arguments: {
          'educationLevel': educationLevels,
          'practicalExperiences': practicalExperiences,
          'PersonalDetails':personalDetails,
        },
      );
    }
  }
}
