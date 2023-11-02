import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/homepage_controller.dart';

class Post extends StatelessWidget {
  Post({Key? key});

  final List<Map<String, dynamic>> posts = [

    {
      'name': 'Obaida Aws',
      'time': '1 hour ago',
      'content': 'Computer engineer in my fifth year at Al Najah University.',
      'image': 'images/obaida.jpeg',
      'like': 85,
      'comment': 33,
      'share': 37,
    },
    {
      'name': 'Islam Aws',
      'time': '2 hours ago',
      'content': 'This is my brother, and he is 8 months old.',
      'image': 'images/islam.jpeg',
      'like': 123,
      'comment': 45,
      'share': 56,
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
                                      controller.goToProfilePage();
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
                              // "Connect" icon here
                              IconButton(
                                onPressed: () {
                                  postController.toggleConnectButton();
                                },
                                icon: Icon(
                                  postController.isConnectButtonPressed.value
                                      ? Icons.people
                                      : Icons.person_add,
                                  size: 32,
                                  color: postController.isConnectButtonPressed.value
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
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
                          const SizedBox(height: 30),
                          Divider(
                color: Color.fromARGB(255, 194, 193, 193),
                thickness: 1.0,
              ),
            
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                
                                 Column(
                                   children: [
                                     Icon(Icons.thumb_up, color: Colors.grey),
                                     Text("Like")
                                   ],
                                 ),
                                
                                 SizedBox(width: 80),
                                 Column(
                                   children: [
                                     Icon(Icons.comment, color: Colors.grey),
                                     Text("Comment")
                                   ],
                                 ),
                                
                                 SizedBox(width: 80),
                                 Column(
                                   children: [
                                     Icon(Icons.share, color: Colors.grey),
                                     Text("Share")
                                   ],
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
