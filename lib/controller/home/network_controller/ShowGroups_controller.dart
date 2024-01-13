import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/chatGroupMessage.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class ShowGroupsController {
  late RxList<Map<String, dynamic>> Groupmessages = <Map<String, dynamic>>[].obs;

   final List<Map<String, dynamic>> admins = [
    
  ];

  final List<Map<String, dynamic>> members = [
   
  ];


Future<http.Response?> getAndLoadPageEmployees(groupid) async {
  var url = "$urlStarter/user/getMyPageGroupInfo?groupId=$groupid";
  var response = await http.get(Uri.parse(url), headers: {
    'Content-type': 'application/json; charset=UTF-8',
    'Authorization': 'bearer ' + GetStorage().read('accessToken'),
  });
var responseBody = jsonDecode(response.body);
  print(response.statusCode);
  print(responseBody['message']);
  if (response.statusCode == 403) {
    await getRefreshToken(GetStorage().read('refreshToken'));
    return getAndLoadPageEmployees(groupid);
  } else if (response.statusCode == 401) {
    _logoutController.goTosigninpage();
    return null; // Or handle as needed in your application
  }

  if (response.statusCode == 409) {
    var responseBody = jsonDecode(response.body);
    print(responseBody['message']);
    return null; // Or handle as needed in your application
  } else if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);
   // print(responseBody);
  
    List<Map<String, dynamic>> members1;
    List<Map<String, dynamic>> admins1;

final List<dynamic> membersobject=responseBody['groupMembers'];
final List<dynamic> adminsobject=responseBody['groupAdmins'];
print("Adas");
print(membersobject);
print("8888888888888");
print(adminsobject);

members.addAll(membersobject.map((member) => {
  'username': member['username'],
  'photo': member['photo'], 
   'firstname': member['user']['firstName'], 
  'lastname': member['user']['lastName'], 
}).toList());


admins.addAll(adminsobject.map((admin) => {
      'username': admin['username'],
      'photo': admin['photo'],
     'firstname': admin['user']['firstName'],
      'lastname': admin['user']['lastName'],
  }).toList());
  
   
   Get.to(GroupChatPageMessages(
      data: Groupmessages[0],admins: admins,members: members,
    ));



   // print(pageEmployees);
    print(";;;;;;;;;;;;;;;;;;;;;");


  }

  return response;
}













///////////////////////////////
  goToGroupChatMessage(pageId) async {

    // here get data for all chat , members,admins,
    print(pageId);
    print("Hamassssssssss");
    print(Groupmessages);
    print("Hamassssssssss");
    Get.to(GroupChatPageMessages(
      data: Groupmessages[0],admins: admins,members: members,
    ));
  }

  List<Map<String, dynamic>> groupsData = [];
  Map<String, bool> isExpandedMap = {}; // Map to store isExpanded status for each group

  GroupsController() {
    

    for (var groupData in groupsData) {
      isExpandedMap[groupData['id']!] = false;
    }
  }

  List<String> get parentGroupNames {
    List<String> names = [];
    for (var groupData in groupsData) {
      if (groupData['parentNode'] == null) {
        names.add(groupData['name']!);
      }
    }
    return names;
  }

  bool isGroupExpanded(String groupId) {
    return isExpandedMap[groupId] ?? false;
  }

  void setGroupExpanded(String groupId, bool isExpanded) {
    isExpandedMap[groupId] = isExpanded;
  }

  Map<String, dynamic>? findGroupById(String groupId) {
    for (var groupData in groupsData) {
      if (groupData['id'] == groupId) {
        return groupData;
      }
    }
    return null;
  }
}
