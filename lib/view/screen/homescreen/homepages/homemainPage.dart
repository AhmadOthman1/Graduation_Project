import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:growify/view/widget/homePage/posts.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    HomePageControllerImp controller = Get.put(HomePageControllerImp());
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ListView(
          children: [
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoute.chatmainpage);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 5, right: 15),
                      child: Icon(
                        Icons.message_rounded,
                        size: 45,
                      ),
                    ),
                  ),
                  // go to chat amd messages

                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: Colors.grey[200],
                        filled: true,
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search",
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          // go to the profile Page
                          Get.to(ProfileMainPage());
                        },
                        child: const CircleAvatar(
                          backgroundImage: AssetImage(
                              'images/obaida.jpeg'), // i need to put the path in imageasset/constant/core
                          radius: 30,
                        ),
                      ))
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
            Post(),
          ],
        ));
  }
}
