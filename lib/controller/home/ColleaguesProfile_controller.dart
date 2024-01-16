import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/ReportPages/ReportColleagues.dart';
import 'package:growify/view/screen/homescreen/chat/chatpagemessages.dart';
import 'package:growify/view/screen/homescreen/profilepages/seeaboutInfoColleagues.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class ColleaguesProfileControllerImp extends GetxController {
late RxList<Map<String, dynamic>> colleaguesmessages= <Map<String, dynamic>>[].obs;


////////////////
  List<String> moreOptions = ['Report',];
onMoreOptionSelected(String option, username) async {
 
      switch (option) {
 
        case 'Report':
        return await  Get.to(ReportProfilePage(username: username,));
          break;
      }
    } 
  



////







  bool isDeleteButtonVisible = false;
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
  getUserProfileInfo(username) async {
    var url =
        "$urlStarter/user/getUserProfileInfo?ProfileUsername=$username";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  goToProfileMainInfo(username) async {
    var res = await getUserProfileInfo(username);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToProfileMainInfo(username);
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
        personalDetails.remove('connection');
        print(personalDetails);
        return true;
      }
    }
  }

  getEducationLevel(username) async {
    var url =
        "$urlStarter/user/usersGetEducationLevel?ProfileUsername=$username";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  goToEducationLevel(username) async {
    var res = await getEducationLevel(username);
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToEducationLevel(username);
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

  Future getWorkExperiencePgae(username) async {
    var url =
        "$urlStarter/user/usersGetworkExperience?ProfileUsername=$username";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  goToWorkExperiencePgae(username) async {
    var res = await getWorkExperiencePgae(username);
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToWorkExperiencePgae(username);
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

  goToAboutInfo(username) async {
    var WorkExperienceInfo = await goToWorkExperiencePgae(username);
    var EducationLevelInfo = await goToEducationLevel(username);
    var ProfileMainInfo = await goToProfileMainInfo(username);
    if (WorkExperienceInfo!=null && EducationLevelInfo!=null && ProfileMainInfo!=null) {
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

  goToChatMessage()async {
    print("Hamassssssssss");
print(colleaguesmessages);
print("Hamassssssssss");
       Get.to(ChatPageMessages(
                      data: colleaguesmessages[0]
                    ));
  }
}
