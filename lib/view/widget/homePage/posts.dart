import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/view/widget/homePage/commentsMainpage.dart';

import 'package:growify/view/widget/homePage/like.dart';
import 'package:growify/view/widget/homePage/thecomments.dart';

class Post extends StatelessWidget {
  Post({Key? key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GetBuilder<HomePageControllerImp>(
        init: HomePageControllerImp(),
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.posts.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final post = controller.posts[index];

              return Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // controller.goToProfilePage();
                                      // For testing purposes, toggle like on image tap
                                     // controller.toggleLike(index);
                                     controller.goToProfileColleaguesPage(post['email']);
                                    },
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(post['image']),
                                      radius: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            post['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        post['time'],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                               PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (String option) {
                                  controller.onMoreOptionSelected(option);
                                },
                                itemBuilder: (BuildContext context) {
                                  return controller.moreOptions.map((String option) {
                                    return PopupMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList();
                                })




                            /*  IconButton(
                                onPressed: () {
                                  // Show more choice

                                },
                                icon: const Icon(Icons.more_vert),
                              )*/
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            post['content'],
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Image.asset(post['image']),
                          const SizedBox(height: 5),
                          Container(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    //go to like page
                                    Get.to(Like());
                                   
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.thumb_up,
                                        color: Colors.blue,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10, right: 5),
                                        child: Text(
                                          '${controller.getLikes(index)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Likes',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Color.fromARGB(255, 194, 193, 193),
                            thickness: 1.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: (){
                                    controller.toggleLike(index);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 35),
                                    child: Column(
                                      children: [
                                        Icon(Icons.thumb_up, color:controller.isLiked(index)
                                            ? Colors.blue
                                            : Colors.grey,),
                                        Text("Like")
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 135),
                                InkWell(
                                  onTap: () {
                                    //go to comment page
                                    Get.to(CommentsMainPage());
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.comment,color: Colors.grey, ),
                                      Text("Comment")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
