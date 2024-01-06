import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/groups_controller.dart';
import 'package:growify/view/screen/homescreen/Groups/creategroup.dart';

class GroupPage extends StatefulWidget {
  final pageId;
  final groupsData;
  const GroupPage({Key? key, required this.pageId, this.groupsData}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final GroupsController groupsController = GroupsController();
  late List<Map<String, dynamic>> groupsDatalocal;
  late Map<String, bool> isExpandedMap;

  @override
  void initState() {
    super.initState();

    groupsDatalocal = List<Map<String, dynamic>>.from(widget.groupsData);

    isExpandedMap = {};

    for (var groupData in groupsDatalocal) {
      isExpandedMap[groupData['name']!] = false; // Change here
    }

   
  }

  Color darkColor = const Color.fromARGB(255, 116, 114, 114)!;
  Color lightColor = Colors.grey[200]!;

  bool isGroupExpanded(String groupName) { // Change here
    return isExpandedMap[groupName] ?? false; // Change here
  }

  void setGroupExpanded(String groupName, bool isExpanded) { // Change here
    isExpandedMap[groupName] = isExpanded; // Change here
  }

  Map<String, dynamic>? findGroupByName(String groupName) { // Change here
    for (var groupData in groupsDatalocal) {
      if (groupData['name'] == groupName) { // Change here
        return groupData;
      }
    }
    return null;
  }

  Widget buildGroupTile(Map<String, dynamic> groupData, int level) {
    String groupName = groupData['name']!; // Change here
    bool isGroupExpanded = isExpandedMap[groupName] ?? false; // Change here
    Color backgroundColor = isGroupExpanded ? lightColor : darkColor;

    return Column(
      children: [
        Card(
          color: backgroundColor,
          child: ListTile(
            title: InkWell(
              onTap: () {
                 Map<String, dynamic> userMap = {
          'name': groupData['name'],
          'username': 'member',
          'id':groupData['id'],
          'pageId':1
      
    };
    groupsController.Groupmessages = <Map<String, dynamic>>[userMap].obs;
                groupsController.goToGroupChatMessage();
              },
              child: Text(
                groupName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: groupData['parentNode'] != null
                ? Text("Parent Node: ${findGroupByName(groupData['parentNode']!)!['name']}")
                : null,
            trailing: InkWell(
              onTap: () {
                setState(() {
                  setGroupExpanded(groupName, !isGroupExpanded); // Change here
                });
              },
              child: Icon(
                isGroupExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                size: 40.0,
              ),
            ),
          ),
        ),
        if (isGroupExpanded)
          Column(
            children: groupsDatalocal
                .where((subgroupData) =>
                    subgroupData['parentNode'] == groupName) // Change here
                .map((subgroupData) {
              return buildGroupTile(subgroupData, level + 1);
            }).toList(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Page'),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(CreateGroupPage());
            },
            child: Text(
              'Create',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: ListView.builder(
          itemCount: groupsDatalocal
              .where((groupData) => groupData['parentNode'] == null)
              .length,
          itemBuilder: (context, index) {
            var parentGroupData = groupsDatalocal
                .where((groupData) => groupData['parentNode'] == null)
                .toList()[index];
            return buildGroupTile(parentGroupData, 0);
          },
        ),
      ),
    );
  }
}
