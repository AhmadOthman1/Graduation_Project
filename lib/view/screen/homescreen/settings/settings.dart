import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/settings_controller.dart';
import 'package:growify/view/screen/homescreen/settings/changeemail.dart';
import 'package:growify/view/screen/homescreen/settings/changepassword.dart';
import 'package:growify/view/screen/homescreen/settings/myPages.dart';

class Settings extends StatelessWidget {
  Settings({super.key});



  SettingsControllerImp controller = Get.put(SettingsControllerImp());

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
                    controller.goToProfileSettingsPgae();
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 10),
                        Text(
                          "Profile settings",
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
                    Get.to(ChangePassword());
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.lock_outlined),
                        SizedBox(width: 10),
                        Text(
                          "Change Password",
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
                    Get.to(ChangeEmail());
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.email_outlined),
                        SizedBox(width: 10),
                        Text(
                          "Change Email",
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
                  controller.goToWorkExperiencePgae();
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.business),
                        SizedBox(width: 10),
                        Text(
                          "Work experience",
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
                  
                 
                 controller.goToEducationLevel();
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.school),
                        SizedBox(width: 10),
                        Text(
                          "Education Level",
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
                  
                  Get.to(MyPages());
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.contact_page),
                        SizedBox(width: 10),
                        Text(
                          "My Pages",
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
            ],
          ),
        ],
      ),
    );
  }
}
