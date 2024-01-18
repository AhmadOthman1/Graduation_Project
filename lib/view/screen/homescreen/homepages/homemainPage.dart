import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/chat/chatForWeb/chatWebmainpage.dart';
import 'package:growify/view/screen/homescreen/chat/chatmainpage.dart';
import 'package:growify/view/screen/homescreen/search/Search.dart';
import 'package:growify/view/screen/homescreen/taskes/tasksmainpage.dart';
import 'package:growify/view/widget/homePage/posts.dart';
import 'package:growify/controller/home/chats_controller/chatmainpage_controller.dart';
import 'package:growify/view/screen/homescreen/chat/chatpagemessages.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late HomePageControllerImp controller;
  final LogOutButtonControllerImp logoutController =
      Get.put(LogOutButtonControllerImp());

  String? name;
  ImageProvider<Object> avatarImage =
      const AssetImage("images/profileImage.jpg");

  @override
  void initState() {
    super.initState();
    if (GetStorage().read("firstname") != null &&
        GetStorage().read("lastname") != null) {
      name =
          GetStorage().read("firstname") + " " + GetStorage().read("lastname");
    }
    controller = Get.put(HomePageControllerImp());
    updateAvatarImage();
  }

  void updateAvatarImage() {
    String profileImage = GetStorage().read("photo") ?? "";
    setState(() {
      avatarImage = (profileImage.isNotEmpty)
          ? Image.network("$urlStarter/$profileImage").image
          : const AssetImage("images/profileImage.jpg");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Color.fromARGB(0,255,251,254), 
                child: InkWell(
                  onTap: () {
                    controller.goToprofilepage();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors
                              .transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage: avatarImage,
                        ),
                        accountName: Text(
                          name ?? "",
                          style: const TextStyle(color: Colors.black),
                        ),
                        accountEmail: const Text(
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
                        title: const Text("Tasks"),
                        leading: const Icon(Icons.task),
                        onTap: () {
                          Get.to(const TasksHomePage());
                        },
                      ),
                      ListTile(
                        title: const Text("My Pages"),
                        leading: const Icon(Icons.contact_page),
                        onTap: () {
                          controller.goToMyPages();
                        },
                      ),
                      ListTile(
                        title: const Text("Log Out"),
                        leading: const Icon(Icons.logout_outlined),
                        onTap: () async {
                          await logoutController.goTosigninpage();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Scaffold(
                body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          onTap: () {
                                            Get.to(const Search());
                                          },
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            fillColor: Colors.grey[200],
                                            filled: true,
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            hintText: "Search",
                                          ),
                                        ),
                                      ),
                                      /* InkWell(
                                        onTap: () {
                                          controller.goToChatPage();
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, left: 3),
                                          child: const Icon(
                                            Icons.message_rounded,
                                            size: 45,
                                          ),
                                        ),
                                      ),*/
                                    ],
                                  ),
                                ),

                                //  Post(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: Row(children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 4,
                      child: Post(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ]),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: ChatWebMainPage(),
              ),
            ),
          ],
        ),
      );
    } else {
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
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Column(
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
                                    Get.to(const Search());
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
                                  controller.goToChatPage();
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, left: 3),
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
                ),
              ),
            ];
          },
          body: Post(),
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
                  decoration: const BoxDecoration(
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
                    name ?? "",
                    style: const TextStyle(color: Colors.black),
                  ),
                  accountEmail: const Text(
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
                  title: const Text("Tasks"),
                  leading: const Icon(Icons.task),
                  onTap: () {
                    Get.to(const TasksHomePage());
                  },
                ),
                ListTile(
                  title: const Text("My Pages"),
                  leading: const Icon(Icons.contact_page),
                  onTap: () {
                    controller.goToMyPages();
                  },
                ),
                ListTile(
                  title: const Text("Log Out"),
                  leading: const Icon(Icons.logout_outlined),
                  onTap: () async {
                    await logoutController.goTosigninpage();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
