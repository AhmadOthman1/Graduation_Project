import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/chatGroupMessage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class CreateGroupsinGroupController {
  late RxList<Map<String, dynamic>> Groupmessages =
      <Map<String, dynamic>>[].obs;

  getPageAllGroup(String pageId) {}

  goToGroupChatMessage() async {
    print("Hamassssssssss");
    print(Groupmessages);
    print("Hamassssssssss");
    Get.to(GroupChatPageMessages(data: Groupmessages[0]));
  }

  List<Map<String, dynamic>> groups = [];


  void setParentNode(
      Map<String, dynamic> group, Map<String, dynamic>? parentNode) {
    group['parentNode'] = parentNode;
  }

  addGroup(Map<String, dynamic> newGroup) async {
    var url = "$urlStarter/user/createPageGroup";

    Map<String, dynamic> jsonData = {
      "pageId": newGroup['pageId'],
      "name": newGroup['name'],
      "parentNode": newGroup['parentNode'],
      "description": newGroup['description'],
    };
    String jsonString = jsonEncode(jsonData);
    int contentLength = utf8.encode(jsonString).length;
    var responce = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    if (responce.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      addGroup(newGroup);
      return;
    } else if (responce.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    print(responce.statusCode);
    if (responce.statusCode == 409 || responce.statusCode == 500) {
       var resbody = jsonDecode(responce.body);
      return resbody['message'];
    } else if (responce.statusCode == 200) {
       var resbody = jsonDecode(responce.body);
      Get.back();
    }
  }

  
 

  List<Map<String, dynamic>> initializeGroups(
      List<Map<String, dynamic>> groupsData) {
    List<Map<String, dynamic>> initializedGroups = [];

    for (var groupData in groupsData) {
      Map<String, dynamic> newGroup = {
        'name': groupData['name'],
        'id': groupData['id'].toString(),
        'parentNode': groupData['id'] ,
        'description': groupData['description'],
      };

      initializedGroups.add(newGroup);
    }

    return initializedGroups;
  }
}
