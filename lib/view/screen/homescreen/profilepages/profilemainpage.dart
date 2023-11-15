import 'package:flutter/material.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/view/widget/homePage/posts.dart';
import 'package:get/get.dart';

class ProfileMainPage extends StatelessWidget {
  final AssetImage _profileImage = AssetImage("images/obaida.jpeg");
  final AssetImage _coverImage = AssetImage("images/flutterimage.png");


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
    return Scaffold(
      appBar: AppBar(
        title: Text("Obaida Profile"),
      ),
      body: Stack(
        children: [
          // Cover Image
          Image(
            image: _coverImage,
            fit: BoxFit.cover,
            height: 200, // Adjust the height as needed
          ),
          // Profile Image and User Details
          Container(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 160), // Space for the cover image
                Align(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: _profileImage,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          children: [
                            Text(
                              "John Doe",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Frontend Developer",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Divider(
                        color: Color.fromARGB(255, 194, 193, 193),
                        thickness: 2.0,
                      ),
                      SizedBox(height: 16),
                      // Add a ListView.builder here
                      Center(
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
    )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
