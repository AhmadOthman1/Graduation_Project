import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/chatGroupMessage.dart';

class Group {
  String name;
  String? imagePath;
  String id;
  String? description;
  Group? parentNode;
  bool isExpanded;

  Group({
    required this.name,
    this.imagePath,
    required this.id,
    this.description,
    this.parentNode,
    this.isExpanded = false,
  });
}

class CreateGroupsController {
  late RxList<Map<String, dynamic>> Groupmessages = <Map<String, dynamic>>[].obs;

  getPageAllGroup(String pageId) {}

  goToGroupChatMessage() async {
    print("Hamassssssssss");
    print(Groupmessages);
    print("Hamassssssssss");
    Get.to(GroupChatPageMessages(data: Groupmessages[0]));
  }

  List<Group> groups = [];

  CreateGroupsController() {
    Group mainGroup = Group(
      name: "Main Group",
      imagePath: null,
      id: "1",
    );

    setParentNode(mainGroup, null);
    groups.add(mainGroup);
  }

  void setParentNode(Group group, Group? parentNode) {
    group.parentNode = parentNode;
  }

  void addGroup(Group newGroup) {
    groups.add(newGroup);
  }

  List<String> get parentGroupNames {
    List<String> names = [];
    for (var group in groups) {
      if (group.parentNode == null) {
        names.add(group.name);
      }
    }
    return names;
  }

  Group? findGroupByName(String groupName) {
    for (var group in groups) {
      if (group.name == groupName) {
        return group;
      }
    }
    return null;
  }
}