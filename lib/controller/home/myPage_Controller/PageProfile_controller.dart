import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/ShowAllGroup.dart';
import 'package:growify/view/screen/homescreen/myPage/editPageProfile.dart';
import 'package:growify/view/screen/homescreen/myPage/seeAboutInfoMyPage.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class PageProfileController extends GetxController {
  // for profile
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;

  // for cover page
  // for cover image
  final RxString coverImageBytes = ''.obs;
  final RxString coverImageBytesName = ''.obs;
  final RxString coverImageExt = ''.obs;

  goToEditPageProfile(userData) {
    Get.to(EditPageProfile(
      userData: userData,
    ));
  }

  late List<Map<String, dynamic>> groupsData = [
    
  ];

  getMyPageGroups(pageId) async {
    var url = "$urlStarter/user/getMyPageGroups?pageId=$pageId";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  goToShowGroupPage(pageId) async {
    var res = await getMyPageGroups(pageId);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToShowGroupPage(pageId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      groupsData.clear();
      groupsData =
          (resbody['pageGroups'] as List<dynamic>).map((dynamic group) {
            print(group);
        return {
          'name': group['name'],
          'id': group['groupId'],
          'description': group['description'],
          'parentNode': group['parentGroup'],
          'membersendmessage': group['memberSendMessage'],
        };
      }).toList();
      
      Get.to(GroupPage(pageId: pageId, groupsData: groupsData));
    }

    //Get.to(GroupPage(pageId: pageId, groupsData: groupsData));
  }
}
