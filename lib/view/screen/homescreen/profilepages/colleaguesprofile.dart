import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/ColleaguesProfile_controller.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/global.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class ColleaguesProfile extends StatelessWidget {
  ColleaguesProfile({super.key, required this.userData}){
         profileImage = (userData[0]["photo"] == null) ? "" : userData[0]["photo"];
       coverImage =
        (userData[0]["coverImage"] == null) ? "" : userData[0]["coverImage"];
        Bio = (userData[0]["bio"] == null) ? "" : userData[0]["bio"];
  }
  final ColleaguesProfileControllerImp controller =
      Get.put(ColleaguesProfileControllerImp());

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
  final List<Map<String, dynamic>> userData;
  final AssetImage defultprofileImage = AssetImage("images/profileImage.jpg");
  String? profileImageBytes;
  String? profileImageBytesName;
  String? profileImageExt;
  String? profileImage;
  ImageProvider<Object>? profileBackgroundImage;
  String? coverImage;
  String? coverImageBytes;
  String? coverImageBytesName;
  String? coverImageExt;
  final AssetImage defultcoverImage = AssetImage("images/coverImage.jpg");
  late ImageProvider<Object> coverBackgroundImage;
  String? Bio;

  @override
  Widget build(BuildContext context) {
    profileBackgroundImage = (profileImage != null && profileImage != "")
        ? Image.network(urlStarter + "/" + profileImage!).image
        : defultprofileImage;

    coverBackgroundImage = (coverImage != null && coverImage != "")
        ? Image.network(urlStarter + "/" + coverImage!).image
        : defultcoverImage;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back, size: 30),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '${userData[0]["firstname"]} ${userData[0]["lastname"]}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 180),
                ],
              ),
            ),
            Divider(
              color: Color.fromARGB(255, 194, 193, 193),
              thickness: 2.0,
            ),
            _buildCoverPhoto(),
            _buildProfileInfo(),
            _buildBio(),
            _Deatalis("The Details"),
            _buildDivider(10),
            _buildButtonsRow(),
            _buildDivider(10),
            _Deatalis("The Posts"),
            _buildPostSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverPhoto() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: controller.coverImageBytes.isNotEmpty
              ? MemoryImage(base64Decode(controller.coverImageBytes.value))
              : coverBackgroundImage,
          //('${urlStarter}/${userData[0]["coverImage"]}'),
          //AssetImage('images/cover.jpg'), // Replace with your image
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: controller.profileImageBytes.isNotEmpty
                ? MemoryImage(base64Decode(controller.profileImageBytes.value))
                : profileBackgroundImage, // Replace with your default photo URL
          ),
          /*CircleAvatar(
            radius: 60,
            backgroundImage:
                //AssetImage('images/obaida.jpeg'), // Replace with your image
                NetworkImage('${urlStarter}/${userData[0]["photo"]}'),
          ),*/
          SizedBox(height: 16),
          Text(
            '${userData[0]["firstname"]} ${userData[0]["lastname"]}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '@${userData[0]["username"]}', // Replace with the actual username
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('Posts', '23'),
              _buildInfoItem('Followers', '167'),
              _buildInfoItem('Following', '243'),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding:
                  const EdgeInsets.symmetric(vertical: 13, horizontal: 140),
              onPressed: () {},
              color: Color.fromARGB(255, 85, 191, 218),
              textColor: Colors.white,
              child: Text('Follow Up'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildBio() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bio",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text('$Bio'),
        ],
      ),
    );
  }

  Widget _Deatalis(String text) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      alignment: Alignment.bottomLeft,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildDivider(double HeigthBetween) {
    return Column(
      children: [
        SizedBox(height: HeigthBetween),
        Divider(
          color: Color.fromARGB(255, 194, 193, 193),
          thickness: 1.5,
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            controller.goToAboutInfo();
          },
          child: Container(
            height: 35,
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Icon(Icons.more_horiz),
                SizedBox(width: 10),
                Text(
                  "See About info",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Icons.arrow_forward, size: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostSection() {
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
