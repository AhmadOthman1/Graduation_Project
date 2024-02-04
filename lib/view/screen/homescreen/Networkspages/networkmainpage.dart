import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/view/screen/homescreen/Networkspages/MyJopAplication.dart';
import 'package:growify/view/screen/homescreen/Networkspages/PagesIfollow.dart';
import 'package:growify/view/screen/homescreen/Networkspages/ShowGroups.dart';
import 'package:growify/view/screen/homescreen/Networkspages/ShowRequestsReceived.dart';
import 'package:growify/view/screen/homescreen/Networkspages/ShowRequestsSent.dart';
import 'package:growify/view/screen/homescreen/Networkspages/showcolleagues.dart';
import 'package:growify/view/screen/homescreen/Networkspages/workplacePages.dart';
import 'package:growify/view/widget/homePage/networkssection.dart';

class NetworksPage extends StatelessWidget {
  final NetworkMainPageControllerImp controller =
      Get.put(NetworkMainPageControllerImp());

  final List<Map<String, dynamic>> sections = [
    {
      'iconchnage': Icons.group_rounded,
      'name': 'Colleagues',
      'iconfixed': Icons.arrow_forward,
    },
    {
      'iconchnage': Icons.people_outline,
      'name': 'Requests Received',
      'iconfixed': Icons.arrow_forward,
    },
    {
      'iconchnage': Icons.people_outline,
      'name': 'Requests Sent',
      'iconfixed': Icons.arrow_forward,
    },
    {
      'iconchnage': Icons.contact_page,
      'name': 'Pages I Follow',
      'iconfixed': Icons.arrow_forward,
    },
    {
      'iconchnage': Icons.contact_page,
      'name': 'My Workplace Pages',
      'iconfixed': Icons.arrow_forward,
    },
    {
      'iconchnage': Icons.diversity_3,
      'name': 'My Groups',
      'iconfixed': Icons.arrow_forward,
    },
    {
      'iconchnage': Icons.work,
      'name': 'My Jop Applications',
      'iconfixed': Icons.arrow_forward,
    },
  ];

  NetworksPage({super.key});
  String username = GetStorage().read("username");

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 2, child: Container()),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes the position of shadow
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: sections.length + 1, // Add 1 for the header
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "My Network",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 194, 193, 193),
                            thickness: 2.0,
                          ),
                        ],
                      );
                    } else {
                      // These are the sections
                      final section = sections[index - 1];
                      return NetworkSection(
                        onPressed: () {
                          // Define your navigation logic here based on the section.
                          switch (index - 1) {
                            case 0:
                              Get.to(const ShowColleagues());

                              break;
                            case 1:
                              Get.to(const ShowRequestsReceived());
                              break;
                            case 2:
                              Get.to(const ShowRequestsSent());
                              break;

                            case 3:
                              Get.to(const ShowPagesIFollow());
                              break;

                            case 4:
                              Get.to(const ShowMyWorkPlacePages());
                              break;

                            case 5:
                              controller.goToShowGroupPage();
                              break;
                            case 6:
                              Get.to(MyJopApllication());
                              break;
                          }
                        },
                        icondata: section['iconchnage'],
                        textsection: section['name'],
                      );
                    }
                  },
                ),
              ),
            ),
            Expanded(flex: 2, child: Container()),
          ],
        ),
      );
    } else {
      return Scaffold(
          body: ListView.builder(
        itemCount: sections.length + 1, // Add 1 for the header
        itemBuilder: (context, index) {
          if (index == 0) {
            // This is the header
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "My Network",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 194, 193, 193),
                  thickness: 2.0,
                ),
              ],
            );
          } else {
            // These are the sections
            final section = sections[index - 1];
            return NetworkSection(
              onPressed: () {
                // Define your navigation logic here based on the section.
                switch (index - 1) {
                  case 0:
                    Get.to(const ShowColleagues());

                    break;
                  case 1:
                    Get.to(const ShowRequestsReceived());
                    break;
                  case 2:
                    Get.to(const ShowRequestsSent());
                    break;

                  case 3:
                    Get.to(const ShowPagesIFollow());
                    break;

                  case 4:
                    Get.to(const ShowMyWorkPlacePages());
                    break;

                  case 5:
                    controller.goToShowGroupPage();
                    break;
                  case 6:
                    Get.to(MyJopApllication());
                    break;
                }
              },
              icondata: section['iconchnage'],
              textsection: section['name'],
            );
          }
        },
      ));
    }
  }
}
