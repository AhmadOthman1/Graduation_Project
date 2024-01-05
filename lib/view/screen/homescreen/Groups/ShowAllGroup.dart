import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/groups_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/Groups/creategroup.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final GroupsController groupsController = GroupsController();
  final double indentationPerLevel = 16.0;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> userMap = {
      'name': 'FrontEnd',
      'username': 'member',
      'photo': null,
      'type': 'U'
    };
    groupsController.Groupmessages.assign(userMap);
  }

  Color darkColor = const Color.fromARGB(
      255, 116, 114, 114)!; // Dark color for parent groups and child groups
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
                //go to chat group
                groupsController.goToGroupChatMessage();
                print("Enterd into chat");
              },
              child: CircleAvatar(
                backgroundImage:
                    (group.imagePath != null && group.imagePath != "")
                        ? Image.network("$urlStarter/${group.imagePath}").image
                        : defaultProfileImage,
              ),
            ),
            trailing: InkWell(
              onTap: () {
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
        if (group.isExpanded && group.subgroups.isNotEmpty)
          Container(
            margin: EdgeInsets.only(
                left: indentationPerLevel * level, right: 8, bottom: 10),
            height: 2.0,
            color: Colors.black, // Adjust the color as needed
          ),
        if (group.isExpanded && group.subgroups.isNotEmpty)
          Column(
            children: group.subgroups.asMap().entries.map((entry) {
              return buildGroupTile(entry.value, level + 1);
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
          itemCount: groupsController.groups.length,
          itemBuilder: (context, index) {
            return buildGroupTile(groupsController.groups[index], 0);
          },
        ),
      ),
    );
  }
}
