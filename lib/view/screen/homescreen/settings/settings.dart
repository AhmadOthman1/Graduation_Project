import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/ProfileSettings_controller.dart';
import 'package:growify/controller/home/settings_controller.dart';
import 'package:growify/view/screen/homescreen/settings/Profilesettings.dart';
import 'package:growify/view/screen/homescreen/settings/changeemail.dart';
import 'package:growify/view/screen/homescreen/settings/changepassword.dart';

class Settings extends StatelessWidget {
  Settings({super.key});



  SettingsControllerImp controller = Get.put(SettingsControllerImp());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, size: 30),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Settings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 180),
              ],
            ),
          ),
          Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: InkWell(
                  onTap: () {
                    controller.goToProfileSettingsPgae();
                  },
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
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
              Divider(
                color: Color.fromARGB(255, 194, 193, 193),
                thickness: 2.0,
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: InkWell(
                  onTap: () {
                    Get.to(ChangePassword());
                  },
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
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
              Divider(
                color: Color.fromARGB(255, 194, 193, 193),
                thickness: 2.0,
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: InkWell(
                  onTap: () {
                    Get.to(ChangeEmail());
                  },
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
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
            ],
          ),
        ],
      ),
    );
  }
}
