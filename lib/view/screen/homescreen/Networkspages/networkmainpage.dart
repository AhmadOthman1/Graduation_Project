import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/core/constant/routes.dart';
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
      'iconchnage': Icons.groups_2,
      'name': 'Groups',
      'iconfixed': Icons.arrow_forward,
      
    },
    {
      'iconchnage': Icons.badge_rounded,
      'name': 'Pages',
      'iconfixed': Icons.arrow_forward,
      
    },
    {
      'iconchnage': Icons.people_outline,
      'name': 'People I follow',
      'iconfixed': Icons.arrow_forward,
      
    },
  ];

   NetworksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sections.length + 1, // Add 1 for the header
      itemBuilder: (context, index) {
        if (index == 0) {
          // This is the header
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "My Network",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          const    Divider(
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
                 // Get.toNamed(AppRoute.colleaguespage);
                 controller.goToShowMyColleagues();
                  break;
                case 1:
                  Get.toNamed(AppRoute.groupspage);
                  break;
                case 2:
                  Get.toNamed(AppRoute.pages);
                  break;
                case 3:
                  Get.toNamed(AppRoute.peopleifollow);
                  break;
              }
            },
            icondata: section['iconchnage'],
            textsection: section['name'],
           
            
          );
        }
      },
    );
  }
}
