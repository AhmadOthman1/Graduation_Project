import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/ReportPages/ReportPage.dart';
import 'package:growify/view/screen/homescreen/myPage/seeAboutinfoPageColleagues.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class ColleaguesPageProfile_Controller extends GetxController {

///////////////////////////
  List<String> moreOptions = ['Report',];
onMoreOptionSelected(String option, pageId) async {
 
      switch (option) {
 
        case 'Report':
        return await  Get.to(ReportPage(pageId: pageId,));
          break;
      }
    } 
  










  /////////////////////////////////
  RxBool isFollowing = false.obs;

  // for profile
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;

  // for cover page
  // for cover image
  final RxString coverImageBytes = ''.obs;
  final RxString coverImageBytesName = ''.obs;
  final RxString coverImageExt = ''.obs;

  toggleFollow(pageId) async {
    if (isFollowing == false) {
      await follow(pageId);
    }else{
      await removeFollow(pageId);
    }
  }
PostRemoveFollow(pageId) async {
    var url = "$urlStarter/user/removePageFollow";

    var responce = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'pageId': pageId,
      }),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      },
    );
    return responce;
  }

  @override
  removeFollow(pageId) async {
    var res = await PostRemoveFollow(pageId);
    print(res.statusCode);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      removeFollow(pageId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      isFollowing.toggle();
    }
  }
  PostFollow(pageId) async {
    var url = "$urlStarter/user/followPage";
  
    var responce = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'pageId': pageId,
      }),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      },
    );
    return responce;
  }

  @override
  follow(pageId) async {
    var res = await PostFollow(pageId);
    print(res.statusCode);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      follow(pageId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    
    if (res.statusCode == 409) {
      var resbody = jsonDecode(res.body);
      return resbody['message'];
    } else if (res.statusCode == 200) {
      isFollowing.toggle();
    }
  }
}
