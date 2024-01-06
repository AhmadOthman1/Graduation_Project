import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/Groups/chatGroupMessage.dart';

class GroupsController {
  late RxList<Map<String, dynamic>> Groupmessages = <Map<String, dynamic>>[].obs;

   final List<Map<String, dynamic>> admins = [
    {
      'firstname': 'Admin',
      'lastname': 'AdminLastName',
      'username': 'admin_username',
      'adminType': 'Admin',
      'photo': null,
      'date': '2022-01-06',
    },
    // Add more default admin data as needed
  ];

  final List<Map<String, dynamic>> members = [
    {
      'firstname': 'John',
      'lastname': 'Doe',
      'username': 'john_doe',
      'adminType': 'Member',
      'photo': null,
      'date': '2022-01-06',
    },
    {
      'firstname': 'Jane',
      'lastname': 'Doe',
      'username': 'jane_doe',
      'adminType': 'Member',
      'photo': null,
      'date': '2022-01-06',
    },
    // Add more default member data as needed
  ];

  goToGroupChatMessage() async {

    // here get data for all chat , members,admins,
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
