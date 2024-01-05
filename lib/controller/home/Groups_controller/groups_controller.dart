import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/Groups/chatGroupMessage.dart';

class Group {
  String name;
  String? imagePath;
  List<Group> subgroups;
  Group? parentNode;
  bool isExpanded; // Add this property

  Group({
    required this.name,
     this.imagePath,
    this.subgroups = const [],
    this.parentNode,
    this.isExpanded = false, // Initialize isExpanded to false
  });
}

class GroupsController {
late RxList<Map<String, dynamic>> Groupmessages= <Map<String, dynamic>>[].obs;





 goToGroupChatMessage()async {
    print("Hamassssssssss");
print(Groupmessages);
print("Hamassssssssss");
       Get.to(GroupChatPageMessages(
                      data: Groupmessages[0]
                    ));
  }
  List<Group> groups = [];

  GroupsController() {
    Group mainGroup = Group(
      name: "Main Group",
      imagePath: null,
      subgroups: [
        Group(
          name: "Parent Group 1",
          imagePath: null,
          subgroups: [
            Group(
              name: "Subgroup 1.1",
              imagePath: null,
            ),
            Group(
              name: "Subgroup 1.2",
              imagePath: null,
            ),
          ],
        ),
        Group(
          name: "Parent Group 2",
          imagePath: null,
          subgroups: [
            Group(
              name: "Subgroup 2.1",
              imagePath: null,
            ),
          ],
        ),
        Group(
          name: "Parent Group 3",
          imagePath: null,
        ),
      ],
    );

    setParentNode(mainGroup, null);
    groups.add(mainGroup);
  }

  void setParentNode(Group group, Group? parentNode) {
    group.parentNode = parentNode;
    for (var subgroup in group.subgroups) {
      setParentNode(subgroup, group);
    }
  }

  void addSubgroup(Group parentGroup, Group subgroup) {
    parentGroup.subgroups.add(subgroup);
  }

  void addGroup(Group newGroup) {
    groups.add(newGroup);
  }

  List<String> get parentGroupNames {
    List<String> names = [];
    for (var group in groups) {
      if (group.parentNode == null) {
        names.add(group.name);
        addImmediateParentGroupNames(group, names);
      }
    }
    return names;
  }

  void addImmediateParentGroupNames(Group group, List<String> names) {
    for (var subgroup in group.subgroups) {
      names.add(subgroup.name);
    }
  }

  Group? findGroupByName(String groupName) {
  for (var group in groups) {
    Group? foundGroup = findGroupInTree(group, groupName);
    if (foundGroup != null) {
      return foundGroup;
    }
  }
  return null;
}

Group? findGroupInTree(Group currentGroup, String groupName) {
  if (currentGroup.name == groupName) {
    return currentGroup;
  }

  for (var subgroup in currentGroup.subgroups) {
    Group? foundGroup = findGroupInTree(subgroup, groupName);
    if (foundGroup != null) {
      return foundGroup;
    }
  }

  return null;
}

}