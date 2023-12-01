import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Post_controller.dart';


class Like extends StatelessWidget {
  final PostControllerImp likeController =
      Get.put(PostControllerImp());

  @override
  Widget build(BuildContext context) {
  
                        var args = Get.arguments;
    RxList<Map<String, dynamic>> likes =
        args != null ? args['likes'] : [];

        likeController.likes.assignAll(likes);




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
                  itemCount: likeController.likes.length,
                  itemBuilder: (context, index) {
                    final colleague = likeController.likes[index];

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
                              backgroundImage: AssetImage(colleague['image']),
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
