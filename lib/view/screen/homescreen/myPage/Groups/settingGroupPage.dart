import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/GroupSetting_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/Admins/GroupAdmins.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/Members/ShowMembers.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/editGroupSettings.dart';


class GroupSettings extends StatelessWidget {
  final admins;
  final members;
  final groupData;

  GroupSettings({super.key, this.admins, this.members, this.groupData});

  GroupSettingsController controller =
      Get.put(GroupSettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back, size: 30),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    "Settings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 180),
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: InkWell(
                  onTap: () {
                    Get.to(EditGroupSettingSettings(userData: [groupData],));
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 10),
                        Text(
                          "Edit Group settings",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward, size: 30),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 194, 193, 193),
                thickness: 2.0,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: InkWell(
                  onTap: () {
                    Get.to(GroupAdmins(pageId:groupData['pageId'],groupId:groupData['id'],localAdmins: admins,));
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.group_rounded),
                        SizedBox(width: 10),
                        Text(
                          "Show Admins",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward, size: 30),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 194, 193, 193),
                thickness: 2.0,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: InkWell(
                  onTap: () {
                    Get.to(ShowMembers(pageId:groupData['pageId'],groupId:groupData['id'],localMembers: members,));
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.group_rounded),
                        SizedBox(width: 10),
                        Text(
                          "Show Members",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward, size: 30),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 194, 193, 193),
                thickness: 2.0,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 360,
        child: FloatingActionButton.extended(
          onPressed: () {
            
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Delete Group"),
                  content: Text("Are you sure you want to delete this group?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {

                        await controller.deleteGroup(groupData['id']);

                        Navigator.of(context).pop();
                        Get.offNamed(AppRoute.homescreen);
                      },
                      child: Text("Delete"),
                    ),
                  ],
                );
              },
            );
          },
          label: Text("Delete Group"),
          icon: Icon(Icons.delete),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
