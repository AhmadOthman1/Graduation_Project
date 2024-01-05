import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/settings_controller.dart';
import 'package:growify/view/screen/homescreen/Groups/CalendarGroup/calendargroup.dart';
import 'package:growify/view/screen/homescreen/Groups/Members/ShowMembers.dart';
import 'package:growify/view/screen/homescreen/Groups/TrelloGroup/trellogroupmain.dart';
import 'package:growify/view/screen/homescreen/settings/changeemail.dart';
import 'package:growify/view/screen/homescreen/settings/changepassword.dart';
import 'package:growify/view/screen/homescreen/settings/myPages.dart';

class GroupSettings extends StatelessWidget {
  GroupSettings({super.key});

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
                  //  controller.goToProfileSettingsPgae();
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 10),
                        Text(
                          "Group settings",
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
                    Get.to(GroupCalender());
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_today_rounded),
                        SizedBox(width: 10),
                        Text(
                          "Calendar",
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
                    Get.to(GroupTrelloHomePage());
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.task),
                        SizedBox(width: 10),
                        Text(
                          "Trello",
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
             Get.to(ShowMembers(pageId:1));
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
    );
  }
}
