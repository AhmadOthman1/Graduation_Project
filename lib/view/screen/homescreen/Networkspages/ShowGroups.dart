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
  late Map<String, bool> isExpandedMap;

  @override
  void initState() {
    super.initState();

    isExpandedMap = {};

    for (var pageData in widget.pagesData) {
      for (var groupData in pageData['groups'] ?? []) {
        isExpandedMap[groupData['name'] ?? ""] = false;
      }
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

  findGroupById(int groupId) {
    for (var groupData in widget.pagesData) {
      if (groupData['id'] == groupId) {
        return groupData['name'];
      }
    }
    return '';
  }

  Widget buildGroupTile(Map<String, dynamic> groupData, int level) {
    String groupName = groupData['name'] ?? "";
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
                groupsController.getAndLoadPageEmployees(groupData['id']);
              },
              child: Text(
                groupName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: groupData['parentNode'] != null
                ? Text("Parent Group: ${findGroupById(groupData['parentNode']!)}")
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
            children: (groupData['groups'] as List<Map<String, dynamic>>?)
                    ?.map((subgroupData) {
                  return buildGroupTile(subgroupData, level + 1);
                })?.toList() ??
                [],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var pageIds = widget.pagesData.map((pageData) => pageData['pageId']).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Group Page'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: ListView.builder(
          itemCount: pageIds.length,
          itemBuilder: (context, pageIndex) {
            var pageId = pageIds[pageIndex];
            var topLevelGroups = widget.pagesData.where((pageData) => pageData['pageId'] == pageId).toList();

            return Column(
              children: [
                // Display the pageId without ExpansionTile
                ListTile(
                  title: Text(
                    pageId ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // Display the top-level groups with parentNode = null using ExpansionTile
                for (var groupData in topLevelGroups)
                  buildGroupTile(groupData, 0),
              ],
            );
          },
        ),
      ),
    );
  }
}
