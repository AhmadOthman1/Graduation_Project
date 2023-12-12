import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Post_controller.dart';
import 'package:growify/global.dart';

class Like extends StatefulWidget {
  @override
  _LikeState createState() => _LikeState();
}

class _LikeState extends State<Like> {
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
/*var args;
RxList<Map<String, dynamic>> likes;
    @override
    void initState() {


      super.initState();
      args = Get.arguments;
      likes = args != null ? args['likes'] : [];
      
    }*/
    var args = Get.arguments;
    RxList<Map<String, dynamic>> likes = args != null ? args['likes'] : [];

    print(likes);

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
                //print(likes.length);
                return ListView.builder(
                  itemCount: likes[0]['data'].length,
                  itemBuilder: (context, index) {
                  //  print(likes.length);
                    final colleague = likes[0]['data'][index];
                    profileImage1 =
                        (colleague['photo'] == null) ? "" : colleague['photo'];
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
