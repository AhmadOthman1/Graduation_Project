import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/network_controller/ShowGroups_controller.dart';

class ShowGroupPage extends StatefulWidget {
  final List<Map<String, dynamic>> pagesData;

  const ShowGroupPage({Key? key, required this.pagesData}) : super(key: key);

  @override
  _ShowGroupPageState createState() => _ShowGroupPageState();
}

class _ShowGroupPageState extends State<ShowGroupPage> {
  final ShowGroupsController groupsController = ShowGroupsController();
  late List<Map<String, dynamic>> groupsDatalocal;
  late Map<String, bool> isExpandedMap;

  @override
  void initState() {
    super.initState();

    groupsDatalocal = List<Map<String, dynamic>>.from(
      widget.pagesData.expand(
        (pageData) => pageData['groups'] as List<Map<String, dynamic>>,
      ),
    );

    isExpandedMap = {};

    for (var groupData in groupsDatalocal) {
      isExpandedMap[groupData['name']!] = false;
    }
  }

  Color darkColor = const Color.fromARGB(255, 116, 114, 114)!;
  Color lightColor = Colors.grey[200]!;

  bool isGroupExpanded(String groupName) {
    return isExpandedMap[groupName] ?? false;
  }

  void setGroupExpanded(String groupName, bool isExpanded) {
    isExpandedMap[groupName] = isExpanded;
  }

  Map<String, dynamic>? findGroupByName(String groupName) {
    for (var groupData in groupsDatalocal) {
      if (groupData['name'] == groupName) {
        return groupData;
      }
    }
    return null;
  }

  Widget buildGroupTile(Map<String, dynamic> groupData, int level) {
    String groupName = groupData['name']!;
    bool isGroupExpanded = isExpandedMap[groupName] ?? false;
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
                  'id': groupData['id'],
                  'description': groupData['description'],
                  'parentNode': groupData['parentNode'],
                  'membersendmessage': groupData['membersendmessage'],
                  'pageId': groupData['pageId'],
                };
                groupsController.Groupmessages = <Map<String, dynamic>>[userMap].obs;
                groupsController.goToGroupChatMessage(groupData['pageId']);
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
                  setGroupExpanded(groupName, !isGroupExpanded);
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
                    subgroupData['parentNode'] == groupName)
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
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: ListView.builder(
          itemCount: widget.pagesData.length,
          itemBuilder: (context, pageIndex) {
            var pageData = widget.pagesData[pageIndex];
            
            // Filter out groups with non-null ParentNode
            var topLevelGroups = pageData['groups'].where((groupData) => groupData['parentNode'] == null).toList();
            
            return ExpansionTile(
              title: Text(
                pageData['pageName'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: topLevelGroups.map<Widget>((groupData) {
                return buildGroupTile(groupData, 0);
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
