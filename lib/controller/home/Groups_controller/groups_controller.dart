import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/Groups/chatGroupMessage.dart';

class GroupsController {
  late RxList<Map<String, dynamic>> Groupmessages = <Map<String, dynamic>>[].obs;

  goToGroupChatMessage() async {
    print("Hamassssssssss");
    print(Groupmessages);
    print("Hamassssssssss");
    Get.to(GroupChatPageMessages(
      data: Groupmessages[0],
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
