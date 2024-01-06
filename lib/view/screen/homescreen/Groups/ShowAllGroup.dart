import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/groups_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/Groups/creategroup.dart';

class GroupPage extends StatefulWidget {
  final pageId;
  const GroupPage({Key? key, required this.pageId}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final GroupsController groupsController = GroupsController();
  final double indentationPerLevel = 16.0;

  @override
  void initState() {
    super.initState();
    dynamic result = groupsController.getPageAllGroup(widget.pageId);

    Map<String, dynamic> userMap = {
      'name': 'FrontEnd',
      'username': 'member',
      'photo': null,
      'type': 'U'
    };
    groupsController.Groupmessages.assign(userMap);
  }

  Color darkColor =
      const Color.fromARGB(255, 116, 114, 114)!; // Dark color for parent groups
  Color lightColor =
      Colors.grey[200]!; // Light color for parent groups and child groups

  Widget buildGroupTile(Group group, int level) {
    Color backgroundColor = group.isExpanded ? lightColor : darkColor;
    final AssetImage defaultProfileImage =
        const AssetImage("images/profileImage.jpg");

    return Column(
      children: [
        Card(
          color: backgroundColor,
          child: ListTile(
            title: Text(group.name),
            subtitle: group.parentNode != null
                ? Text("Parent Node: ${group.parentNode!.name}")
                : null,
            leading: InkWell(
              onTap: () {
                groupsController.goToGroupChatMessage();
                
              },
              child: CircleAvatar(
                backgroundImage: (group.imagePath != null && group.imagePath != "")
                    ? Image.network("$urlStarter/${group.imagePath}").image
                    : defaultProfileImage,
              ),
            ),
            trailing: InkWell(
              onTap: () {
                // Toggle the expansion state
                setState(() {
                  group.isExpanded = !group.isExpanded;
                });
              },
              child: Icon(
                group.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 40.0, // Adjust the size as needed
              ),
            ),
          ),
        ),
        if (group.isExpanded)
          Column(
            children: groupsController.groups
                .where((subgroup) => subgroup.parentNode == group)
                .map((subgroup) {
              return buildGroupTile(subgroup, level + 1);
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
              // Navigate to the create group page
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
          itemCount: groupsController.parentGroupNames.length,
          itemBuilder: (context, index) {
            var parentGroupName = groupsController.parentGroupNames[index];
            var parentGroup = groupsController.findGroupByName(parentGroupName);
            if (parentGroup != null) {
              return buildGroupTile(parentGroup, 0);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
