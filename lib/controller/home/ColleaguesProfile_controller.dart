import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:growify/view/screen/homescreen/profilepages/seeaboutInfoColleagues.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class ColleaguesProfileControllerImp extends GetxController {
  RxString result = ''.obs;
  void toggleResult() {
    /*if (result.value == 'Following') {
      result.value = 'Follow';
    } else if (result.value == 'Follow') {
      result.value = 'Requested';
    } else if (result.value == 'Requested') {
      result.value = 'Follow';
    }*/

    update();
  }
  postSendDeleteReq(username) async {
    var url = "$urlStarter/user/postSendDeleteReq";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({"username": username}),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),
        });
    return responce;
  }

  sendDeleteReq(username) async {
    try {
      var res = await postSendDeleteReq(username);

      if (res.statusCode == 403) {
        await getRefreshToken(GetStorage().read('refreshToken'));
        await sendDeleteReq(username);
        return null;
      } else if (res.statusCode == 401) {
        _logoutController.goTosigninpage();
      }
      var resbody = jsonDecode(res.body);
      if (res.statusCode == 409 || res.statusCode == 500) {
        return resbody['message'];
      } else if (res.statusCode == 200) {
        resbody['message'] = "";
        result.value = "Connect";
        isDeleteButtonVisible= false;
        update();
        return null;
      }
    } catch (err) {
      print(err);
      return "server error";
    }
    update();
  }
postSendAcceptConnectReq(username) async {
    var url = "$urlStarter/user/postSendAcceptConnectReq";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({"username": username}),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),
        });
    return responce;
  }

  sendAcceptConnectReq(username) async {
    try {
      var res = await postSendAcceptConnectReq(username);

      if (res.statusCode == 403) {
        await getRefreshToken(GetStorage().read('refreshToken'));
        await sendAcceptConnectReq(username);
        return null;
      } else if (res.statusCode == 401) {
        _logoutController.goTosigninpage();
      }
      var resbody = jsonDecode(res.body);
      if (res.statusCode == 409 || res.statusCode == 500) {
        return resbody['message'];
      } else if (res.statusCode == 200) {
        resbody['message'] = "";
        result.value = "Connected";
        isDeleteButtonVisible= false;
        update();
        return null;
      }
    } catch (err) {
      print(err);
      return "server error";
    }
    update();
  }
  postSendConnectReq(username) async {
    var url = "$urlStarter/user/postSendConnectReq";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({"username": username}),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),
        });
    return responce;
  }

  sendConnectReq(username) async {
    try {
      var res = await postSendConnectReq(username);

      if (res.statusCode == 403) {
        await getRefreshToken(GetStorage().read('refreshToken'));
        await sendConnectReq(username);
        return null;
      } else if (res.statusCode == 401) {
        _logoutController.goTosigninpage();
      }
      var resbody = jsonDecode(res.body);
      if (res.statusCode == 409 || res.statusCode == 500) {
        return resbody['message'];
      } else if (res.statusCode == 200) {
        resbody['message'] = "";
        result.value = "Requested";
        update();
        return null;
      }
    } catch (err) {
      print(err);
      return "server error";
    }
    update();
  }
  postSendRemoveReq(username) async {
    var url = "$urlStarter/user/postSendRemoveReq";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({"username": username}),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),
        });
    return responce;
  }

  sendRemoveReq(username) async {
    try {
      var res = await postSendRemoveReq(username);

      if (res.statusCode == 403) {
        await getRefreshToken(GetStorage().read('refreshToken'));
        await sendRemoveReq(username);
        return null;
      } else if (res.statusCode == 401) {
        _logoutController.goTosigninpage();
      }
      var resbody = jsonDecode(res.body);
      if (res.statusCode == 409 || res.statusCode == 500) {
        return resbody['message'];
      } else if (res.statusCode == 200) {
        resbody['message'] = "";
        result.value = "Connect";
        update();
        return null;
      }
    } catch (err) {
      print(err);
      return "server error";
    }
    update();
  }
    postSendRemoveConnection(username) async {
    var url = "$urlStarter/user/postSendRemoveConnection";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({"username": username}),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),
        });
    return responce;
  }

  sendRemoveConnection(username) async {
    try {
      var res = await postSendRemoveConnection(username);

      if (res.statusCode == 403) {
        await getRefreshToken(GetStorage().read('refreshToken'));
        await sendRemoveConnection(username);
        return null;
      } else if (res.statusCode == 401) {
        _logoutController.goTosigninpage();
      }
      var resbody = jsonDecode(res.body);
      if (res.statusCode == 409 || res.statusCode == 500) {
        return resbody['message'];
      } else if (res.statusCode == 200) {
        resbody['message'] = "";
        result.value = "Connect";
        update();
        return null;
      }
    } catch (err) {
      print(err);
      return "server error";
    }
    update();
  }

  //////////////////////////////////////
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
    var url =
        "$urlStarter/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url), headers: {
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
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      if (resbody['user'] is Map<String, dynamic>) {
        // If the 'user' field is a Map, assign it to personalDetails
        personalDetails.assignAll(resbody['user']);
        print(personalDetails);
        Get.to(ProfileMainPage(userData: [resbody["user"]]));
        return true;
      }
    }
  }

  getEducationLevel() async {
    var url =
        "$urlStarter/user/getEducationLevel?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  goToEducationLevel() async {
    var res = await getEducationLevel();
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToEducationLevel();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
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
    var url =
        "$urlStarter/user/getworkExperience?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  goToWorkExperiencePgae() async {
    var res = await getWorkExperiencePgae();
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToWorkExperiencePgae();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
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
    if (WorkExperienceInfo && EducationLevelInfo && ProfileMainInfo) {
      Get.to(
        SeeAboutInfoColleagues(),
        arguments: {
          'educationLevel': educationLevels,
          'practicalExperiences': practicalExperiences,
          'PersonalDetails': personalDetails,
        },
      );
    }
  }
}
