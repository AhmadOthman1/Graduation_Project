import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Post_controller.dart';
import 'package:growify/global.dart';

class Like extends StatelessWidget {
  final PostControllerImp likeController = Get.put(PostControllerImp());
  final AssetImage defultprofileImage1 =
      const AssetImage("images/profileImage.jpg");
  String? profileImageBytes1;
  String? profileImageBytesName1;
  String? profileImageExt1;
  String? profileImage1;
  ImageProvider<Object>? profileBackgroundImage1;

  @override
  Widget build(BuildContext context) {
    var args = Get.arguments;
    RxList<Map<String, dynamic>> likes = args != null ? args['likes'] : [];

    //likeController.likes.assignAll(likes);

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
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    "Likes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Expanded(
            child: GetBuilder<PostControllerImp>(
              builder: (likeController) {
                return ListView.builder(
                  itemCount: likeController.likes1.length,
                  itemBuilder: (context, index) {
                    final colleague = likeController.likes1[index];
                    profileImage1 =
                        (colleague['image'] == null) ? "" : colleague['image'];
                    profileBackgroundImage1 = (profileImage1 != null &&
                            profileImage1 != "")
                        ? Image.network("$urlStarter/" + profileImage1!).image
                        : defultprofileImage1;

                    return Column(
                      children: [
                        ListTile(
                          leading: InkWell(
                            onTap: () {
                              // Navigate to colleague's profile
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => ColleaguesProfile(),
                              // ));
                            },
                            child: CircleAvatar(
                              backgroundImage: likeController
                                      .profileImageBytes1.isNotEmpty
                                  ? MemoryImage(base64Decode(
                                      likeController.profileImageBytes1.value))
                                  : profileBackgroundImage1,
                            ),
                          ),
                          title: Text(colleague['name']),
                          subtitle: Text(colleague['username']),
                        ),
                        const Divider(
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
