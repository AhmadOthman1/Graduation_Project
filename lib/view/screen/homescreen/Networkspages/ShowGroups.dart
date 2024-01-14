import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/network_controller/ShowGroups_controller.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/creategroup.dart';

class ShowGroupPage extends StatefulWidget {
  final pagesData;
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

    groupsDatalocal = List<Map<String, dynamic>>.from(widget.pagesData);

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

  findGroupByName(int groupId) {
    for (var groupData in groupsDatalocal) {
      if (groupData['id'] == groupId) {
        return groupData['name'];
      }
    }
    return;
  }

  Widget buildPageSection(String pageId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Page $pageId',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: groupsDatalocal
                .where((groupData) =>
                    groupData['parentNode'] == null &&
                    groupData['pageId'] == pageId)
                .length,
            itemBuilder: (context, index) {
              var parentGroupData = groupsDatalocal
                  .where((groupData) =>
                      groupData['parentNode'] == null &&
                      groupData['pageId'] == pageId)
                  .toList()[index];
              return buildGroupTile(parentGroupData, 0);
            },
          ),
        ),
      ],
    );
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
                  'pageId':groupData['pageId']
                };
                groupsController.Groupmessages =
                    <Map<String, dynamic>>[userMap].obs;
                groupsController.getAndLoadPageEmployees(groupData['id']);
              },
              child: Text(
                groupName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: groupData['parentNode'] != null
                ? Text(
                    "Parent Group: ${findGroupByName(groupData['parentNode']!)}")
                : null,
            trailing: InkWell(
              onTap: () {
                setState(() {
                  setGroupExpanded(groupName, !isGroupExpanded);
                });
              },
              child: Icon(
                isGroupExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 40.0,
              ),
            ),
          ),
        ),
        if (isGroupExpanded)
          Column(
            children: groupsDatalocal
                .where((subgroupData) =>
                    subgroupData['parentNode'] ==
                        groupData['id'] &&
                    subgroupData['pageId'] == groupData['pageId'])
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
      body: ListView.builder(
        itemCount: widget.pagesData
            .map((page) => page['pageId'])
            .toSet()
            .length, // Count unique page IDs
        itemBuilder: (context, index) {
          var pageId = widget.pagesData
              .map((page) => page['pageId'])
              .toSet()
              .toList()[index];
          return buildPageSection(pageId);
        },
      ),
    );
  }
}
