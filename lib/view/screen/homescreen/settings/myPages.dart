import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/controller/home/myPages_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/chat/chatForWeb/chatWebmainpage.dart';
import 'package:growify/view/screen/homescreen/myPage/Pageprofile.dart';
import 'package:growify/view/screen/homescreen/settings/createPage.dart';
import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/taskes/tasksmainpage.dart';

class MyPages extends StatefulWidget {
  _MyPagesState createState() => _MyPagesState();

  MyPages({super.key});
}

final MyPagesController controller = MyPagesController();
final AssetImage defultprofileImage =
    const AssetImage("images/profileImage.jpg");
ImageProvider<Object>? profileBackgroundImage;
late HomePageControllerImp HPcontroller = Get.put(HomePageControllerImp());
ImageProvider<Object> avatarImage = const AssetImage("images/profileImage.jpg");
String name =
    GetStorage().read("firstname") + " " + GetStorage().read("lastname");
final LogOutButtonControllerImp logoutController =
    Get.put(LogOutButtonControllerImp());

class _MyPagesState extends State<MyPages> {
  @override
  void initState() {
    // TODO: implement initState
    updateAvatarImage();
    super.initState();
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
    //Image.network(pages[index].image)
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Pages",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(const CreatePage());
              },
              child: const Text(
                "Create",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Color.fromARGB(0, 255, 251, 254),
                child: InkWell(
                  onTap: () {
                    HPcontroller.goToprofilepage();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
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
                          HPcontroller.goToSettingsPgae();
                        },
                      ),
                      ListTile(
                        title: const Text("Calender"),
                        leading: const Icon(Icons.calendar_today_rounded),
                        onTap: () {
                          HPcontroller.goToCalenderPage();
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
                          HPcontroller.goToMyPages();
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
              child: Center(
                child: FutureBuilder<List<PageInfo>?>(
                  future: controller.getMyPagesData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<PageInfo>? pages = snapshot.data;

                      if (pages == null || pages.isEmpty) {
                        return const Text('You don\'t have any pages.');
                      }

                      return ListView.builder(
                        itemCount: pages.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              print("AAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                              print(pages[index]);
                              print(pages[index].photo);
                              Get.to(PageProfile(
                                  isAdmin: true, userData: pages[index]));
                            },
                            child: Card(
                              //margin: EdgeInsets.all(10),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                      //padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 85, 191, 218),
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: pages[index].photo !=
                                                    null &&
                                                pages[index].photo != ""
                                            ? NetworkImage(
                                                "$urlStarter/${pages[index].photo!}")
                                            : const AssetImage(
                                                    "images/profileImage.jpg")
                                                as ImageProvider<Object>,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      pages[index].name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Divider(
                                      color: Color.fromARGB(255, 194, 193, 193),
                                      thickness: 2.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
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
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Pages",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(const CreatePage());
              },
              child: const Text(
                "Create",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: FutureBuilder<List<PageInfo>?>(
            future: controller.getMyPagesData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<PageInfo>? pages = snapshot.data;

                if (pages == null || pages.isEmpty) {
                  return const Text('You don\'t have any pages.');
                }

                return ListView.builder(
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print("AAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                        print(pages[index]);
                        print(pages[index].photo);
                        Get.to(
                            PageProfile(isAdmin: true, userData: pages[index]));
                      },
                      child: Card(
                        elevation: 5,
                        //margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                //padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 85, 191, 218),
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: pages[index].photo != null &&
                                          pages[index].photo != ""
                                      ? NetworkImage(
                                          "$urlStarter/${pages[index].photo!}")
                                      : const AssetImage(
                                              "images/profileImage.jpg")
                                          as ImageProvider<Object>,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                pages[index].name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const Divider(
                                color: Color.fromARGB(255, 194, 193, 193),
                                thickness: 2.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      );
    }
  }
}
