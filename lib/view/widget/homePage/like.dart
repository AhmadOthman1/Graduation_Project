import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/homepage_controller.dart';

class Like extends StatelessWidget {
  Like({super.key});

  final HomePageControllerImp likeController = Get.put(HomePageControllerImp());

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
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Likes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Expanded(
            child: GetBuilder<HomePageControllerImp>(
              builder: (likeController) {
                return ListView.builder(
                  itemCount: likeController.likes.length,
                  itemBuilder: (context, index) {
                    final colleague = likeController.likes[index];

                    return Column(
                      children: [
                        ListTile(
                          leading: InkWell(
                            onTap: () {
                              // Get.to(ColleaguesProfile());
                            },
                            child: CircleAvatar(
                              backgroundImage: AssetImage(colleague['image']),
                            ),
                          ),
                          title: Text(colleague['name']),
                          subtitle: Text(colleague['username']),
                        ),
                        Divider(
                          color: Color.fromARGB(255, 194, 193, 193),
                          thickness: 2.0,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}