import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/ColleaguesPageProfile.dart';
import 'package:growify/view/screen/homescreen/myPage/Pageprofile.dart';
import 'package:growify/view/screen/homescreen/search/Search.dart';
import 'package:growify/view/widget/homePage/posts.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late HomePageControllerImp controller;
  final LogOutButtonControllerImp logoutController = Get.put(LogOutButtonControllerImp());
  
  String name = GetStorage().read("firstname")??"" + " "+ GetStorage().read("lastname")??"";
  ImageProvider<Object> avatarImage = AssetImage("images/profileImage.jpg");

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomePageControllerImp());
    updateAvatarImage();
  }

  void updateAvatarImage() {
    String profileImage = GetStorage().read("photo") ?? "";
    setState(() {
      avatarImage = (profileImage.isNotEmpty)
          ? Image.network("$urlStarter/$profileImage").image
          : AssetImage("images/profileImage.jpg");
    });
  }

  @override
  Widget build(BuildContext context) {
    Builder avatarBuilder = Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(right: 2),
        child: InkWell(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: CircleAvatar(
            backgroundImage: avatarImage,
            radius: 30,
          ),
        ),
      );
    });

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView(
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  avatarBuilder,
                  Expanded(
                    child: TextFormField(
                      onTap: () {
                        Get.to(Search());
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search",
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      controller.goToChat();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 5, left: 3),
                      child: const Icon(
                        Icons.message_rounded,
                        size: 45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Color.fromARGB(255, 194, 193, 193),
              thickness: 4.0,
            ),
          //  Post(),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: InkWell(
          onTap: () {
            controller.goToprofilepage();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: avatarImage,
                ),
                accountName: Text(
                  name,
                  style: TextStyle(color: Colors.black),
                ),
                accountEmail: Text(
                  "View profile",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ListTile(
                title: const Text("Settings"),
                leading: const Icon(Icons.settings),
                onTap: () {
                  controller.goToSettingsPgae();
                },
              ),
              ListTile(
                title: const Text("Calender"),
                leading: const Icon(Icons.calendar_today_rounded),
                onTap: () {
                  controller.goToCalenderPage();
                },
              ),
              ListTile(
                title: const Text("Log Out"),
                leading: const Icon(Icons.logout_outlined),
                onTap: () {
                  logoutController.goTosigninpage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
