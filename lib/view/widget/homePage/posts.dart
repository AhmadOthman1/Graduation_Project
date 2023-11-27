import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/homepage_controller.dart';

import 'package:growify/view/widget/homePage/like.dart';
import 'package:growify/view/widget/homePage/thecomments.dart';

class Post extends StatelessWidget {
  Post({Key? key});

  final List<Map<String, dynamic>> posts = [
    {
      'name': 'Obaida Aws',
      'time': '1 hour ago',
      'content': 'Computer engineer in my fifth year at Al Najah University.',
      'image': 'images/obaida.jpeg',
      'like': 165,
      
    },
    {
      'name': 'Islam Aws',
      'time': '2 hours ago',
      'content': 'This is my brother, and he is 8 months old.',
      'image': 'images/islam.jpeg',
      'like': 123,
     
    },

    // Add more posts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: posts.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final post = posts[index];
          final controller = HomePageControllerImp();

          return GetBuilder<HomePageControllerImp>(
            init: controller,
            builder: (postController) {
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
                                      controller.goToProfileColleaguesPage();
                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage(post['image']),
                                      radius: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              // "Connect" icon here
                              IconButton(
                                onPressed: () {
                                  //show  more cjoise
                                  
                                },
                                icon: Icon(Icons.more_vert),
                              )
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
                          //  width: 200,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: (){
                                    //go to like page
                                    Get.to(Like());
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.thumb_up,color: Colors.grey,),
                                      Container(
                                          margin: EdgeInsets.only(left: 10,right: 5),
                                         
                                            child: Text(
                                              '${post['like']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,color: Colors.grey),
                                            ),
                                          ),
                                          Text('Likes',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),)
                                          
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
                                Container(
                                  margin: EdgeInsets.only(left: 35),
                                  child: Column(
                                    children: [
                                      Icon(Icons.thumb_up, color: Colors.grey),
                                      Text("Like")
                                    ],
                                  ),
                                ),
                                SizedBox(width: 135),
                                InkWell(
                                  onTap: (){
                                    //go to comment page
                                   // Get.to(CommentPage());
                                   Get.to(Like());
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.comment, color: Colors.grey),
                                      Text("Comment")
                                    ],
                                  ),
                                ),
                                // SizedBox(width: 80),
                                /*  Column(
                                  children: [
                                    Icon(Icons.share, color: Colors.grey),
                                    Text("Share")
                                  ],
                                ),*/
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
