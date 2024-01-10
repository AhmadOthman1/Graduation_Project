import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/chatGroupMessage.dart';

class CreateGroupsController {
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

  CreateGroupsController({required List<Map<String, dynamic>> groupsData}) {
    groups = initializeGroups(groupsData);
  }

  void setParentNode(Map<String, dynamic> group, Map<String, dynamic>? parentNode) {
    group['parentNode'] = parentNode;
  }

  void addGroup(Map<String, dynamic> newGroup) {
    groups.add(newGroup);
  }

  List<String> get parentGroupNames {
    List<String> names = [];
    for (var group in groups) {
      if (group['parentNode'] == null) {
        names.add(group['name']);
      }
    }
    return names;
  }

  Map<String, dynamic>? findGroupByName(String groupName) {
    for (var group in groups) {
      if (group['name'] == groupName) {
        return group;
      }
    }
    return null;
  }

  List<Map<String, dynamic>> initializeGroups(List<Map<String, dynamic>> groupsData) {
    List<Map<String, dynamic>> initializedGroups = [];

    for (var groupData in groupsData) {
      Map<String, dynamic> newGroup = {
        'name': groupData['name'],
        'id': groupData['id'].toString(),
        'parentNode': (groupData['parentNode'] != null)
            ? findGroupByName(groupData['parentNode'].toString())
            : null,
        'description': groupData['description'],
      };

      initializedGroups.add(newGroup);
    }

    return initializedGroups;
  }
}