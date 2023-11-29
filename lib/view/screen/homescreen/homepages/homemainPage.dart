import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/view/screen/homescreen/search/Search.dart';
import 'package:growify/view/widget/homePage/posts.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    HomePageControllerImp controller = Get.put(HomePageControllerImp());
    if(true){
      //bcrypt => enmail+pass > front , email bcrypt
    }
    LogOutButtonControllerImp logoutController = Get.put(LogOutButtonControllerImp());
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
                    Builder(builder: (context) {
                      return Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: InkWell(
                            onTap: () {
                              // go to the profile Page
                              // Get.to(ProfileMainPage());
                              Scaffold.of(context).openDrawer();
                            },
                            child: const CircleAvatar(
                              backgroundImage: AssetImage(
                                  'images/obaida.jpeg'), // i need to put the path in imageasset/constant/core
                              radius: 30,
                            ),
                          ));
                    }),
                    Expanded(
                      child: TextFormField(
                        onTap: (){
                          Get.to(Search());
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          fillColor: Colors.grey[200],
                          filled: true,
                          prefixIcon: const Icon(Icons.search),
                          hintText: "Search",
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoute.chatmainpage);
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
              const Post(),
            ],
          )),
      drawer: Drawer(
        // width: 200,
        backgroundColor: Colors.white,
        child: InkWell(
          onTap: (){
           // Get.to(ProfileMainPage());
           controller.goToprofilepage();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UserAccountsDrawerHeader(
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
                  backgroundImage: AssetImage('images/obaida.jpeg'),
                ),
                accountName: Text(
                  "Obaida Aws",
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
