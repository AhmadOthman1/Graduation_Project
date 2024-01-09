import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/Groups/chatGroupMessage.dart';

class GroupsController {
  late RxList<Map<String, dynamic>> Groupmessages = <Map<String, dynamic>>[].obs;

   final List<Map<String, dynamic>> admins = [
    {
      'firstname': 'Ahmad',
      'lastname': 'Othman',
      'username': 'AhmadOthman',
      'photo': null,
    },

    {
      'firstname': 'Obaida',
      'lastname': 'Aws',
      'username': 'ObaidaAws',
      'photo': null,
    },

    {
      'firstname': 'Mazen',
      'lastname': 'Fursan',
      'username': 'MazenFursan',
      'photo': null,
    },


    {
      'firstname': 'Mohammad',
      'lastname': 'Fadi',
      'username': 'MohammadFadi',
      'photo': null,
    },

    {
      'firstname': 'Hossam',
      'lastname': 'Moaeead',
      'username': 'HossamMoaeead',
      'photo': null,
    },
  ];

  final List<Map<String, dynamic>> members = [
    {
      'firstname': 'Obaida',
      'lastname': 'Aws',
      'username': 'obaida_aws',
      'memberType': 'Employee',
      'photo':null

    },
    {
      'firstname': 'Jane',
      'lastname': 'Doe',
      'username': 'jane_doe',
      'MemberType': 'Not Employee',
      'photo':null
    },
  ];

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
