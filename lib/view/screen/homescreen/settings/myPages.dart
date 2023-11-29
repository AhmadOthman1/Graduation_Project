import 'package:flutter/material.dart';
import 'package:growify/controller/home/myPages_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/settings/createPage.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/myPage_Controller/PageDetails_controller.dart' as PageDetails_controller;

class MyPages extends StatelessWidget {
  final MyPagesController controller = MyPagesController();
  final AssetImage defultprofileImage = const AssetImage("images/profileImage.jpg");
  ImageProvider<Object>? profileBackgroundImage;

  MyPages({super.key});
  @override
  Widget build(BuildContext context) {
    //Image.network(pages[index].image)

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageDetails_controller.goToMyPageInfo(pages[index].id),
                        ),
                      );
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
                                  color: const Color.fromARGB(255, 85, 191, 218),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: pages[index].photo != null &&
                                        pages[index].photo != ""
                                    ? NetworkImage(
                                        "$urlStarter/" + pages[index].photo!)
                                    : const AssetImage("images/profileImage.jpg")
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
