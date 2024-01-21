import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/ShowAllGroup.dart';
import 'package:growify/view/screen/homescreen/myPage/chat/PageChatMainPage.dart';
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
final RxList<Map<String, dynamic>> colleaguesPreviousmessages =
      <Map<String, dynamic>>[].obs;
  goToEditPageProfile(userData) {
    Get.to(EditPageProfile(
      userData: userData,
    ));
  }

  late List<Map<String, dynamic>> groupsData = [];

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

  getChats(pageId) async {
    var url = "$urlStarter/user/pageGetChats?pageId=${pageId}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  goToChat(pageId) async {
    var res = await getChats(pageId);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToChat(pageId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      colleaguesPreviousmessages.clear();
      for (var conversation
          in List<Map<String, dynamic>>.from(resbody['uniqueConversations'])) {
        var name;
        var username;
        var photo;
        String type = "U";
        if (conversation['senderUsername_FK'] != null &&
            conversation['senderUsername_FK']['username'] !=
                GetStorage().read('username')) {
          name = conversation['senderUsername_FK']['firstName'] +
              " " +
              conversation['senderUsername_FK']['lastName'];
          username = conversation['senderUsername_FK']['username'];
          photo = conversation['senderUsername_FK']['photo'];
          type = "U";
        } else if (conversation['receiverUsername_FK'] != null &&
            conversation['receiverUsername_FK']['username'] !=
                GetStorage().read('username')) {
          name = conversation['receiverUsername_FK']['firstName'] +
              " " +
              conversation['receiverUsername_FK']['lastName'];
          username = conversation['receiverUsername_FK']['username'];
          photo = conversation['receiverUsername_FK']['photo'];
          type = "U";
        } else if (conversation['senderPageId_FK'] != null) {
          name = conversation['senderPageId_FK']['name'];
          username = conversation['senderPageId_FK']['id'];
          photo = conversation['senderPageId_FK']['photo'];
          type = "P";
        } else if (conversation['receiverPageId_FK'] != null) {
          name = conversation['receiverPageId_FK']['name'];
          username = conversation['receiverPageId_FK']['id'];
          photo = conversation['receiverPageId_FK']['photo'];
          type = "P";
        }
        final Map<String, dynamic> extractedInfo = {
          'name': name,
          'username': username,
          'photo': photo,
          'type': type,
        };

        colleaguesPreviousmessages.add(extractedInfo);
      }
      //print(colleaguesPreviousmessages);
    }
  }

  goToChatPage(String pageId,pageName,pagePhoto) async {
    await goToChat(pageId);
    Get.to(PageChatMainPage(pageId:pageId,pageName:pageName,pagePhoto:pagePhoto), arguments: {
      'colleaguesPreviousmessages': colleaguesPreviousmessages,
    });
  }
}
