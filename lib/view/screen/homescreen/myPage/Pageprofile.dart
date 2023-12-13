import 'package:flutter/material.dart';
import 'package:growify/controller/home/myPage_Controller/PageProfile_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/NewPost/newpost.dart';
import 'package:growify/view/screen/homescreen/myPage/editPageProfile.dart';
import 'package:growify/view/screen/homescreen/settings/settings.dart';
import 'package:growify/view/widget/homePage/posts.dart';
import 'package:get/get.dart';
import 'dart:convert';

class PageProfile extends StatefulWidget {
  final List<Map<String, dynamic>> userData;

  PageProfile({Key? key, required this.userData}) : super(key: key);

  @override
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  final PageProfileController controller = Get.put(PageProfileController());

  late String? profileImage;
  late String? coverImage;
  late String? Description;
  late String? firstName;

  final AssetImage defaultProfileImage = const AssetImage("images/profileImage.jpg");
  late ImageProvider<Object>? profileBackgroundImage;

  final AssetImage defaultCoverImage = const AssetImage("images/coverImage.jpg");
  late ImageProvider<Object> coverBackgroundImage;

  @override
  void initState() {
    super.initState();
    initializeUserData();
  }

  void initializeUserData() {
    profileImage = widget.userData[0]["photo"] ?? "";
    coverImage = widget.userData[0]["coverImage"] ?? "";
    Description = widget.userData[0]["Description"] ?? "";
    firstName = widget.userData[0]['firstname'];
    loadImages();
  }

  void loadImages() {
    profileBackgroundImage = loadImage(profileImage, defaultProfileImage);
    coverBackgroundImage = loadImage(coverImage, defaultCoverImage);
  }

  ImageProvider<Object> loadImage(String? imageUrl, AssetImage defaultImage) {
    return (imageUrl != null && imageUrl.isNotEmpty)
        ? Image.network("$urlStarter/$imageUrl").image
        : defaultImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
         SliverToBoxAdapter(
          child: Column(
              children: [
                _buildCoverPhoto(),
                _buildProfileInfo(),
                _Details("Details"),
                _buildDivider(10),
                _buildButtonsRow(),
                _buildDivider(10),
                _Details("Posts"),
              //  Expanded(
                 // child: Post(username: widget.userData[0]["username"]), // Use Expanded for the Post widget
               // ),
              ],
            ),
        ),
        ];
        },
        body: Post(),
      ),
    );
  }

  Widget _buildCoverPhoto() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: coverBackgroundImage ?? defaultCoverImage,
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
            backgroundImage: profileBackgroundImage ?? defaultProfileImage,
          ),
          const SizedBox(height: 16),
          Text(
            '$firstName ',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Text(
                  '$Description',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('Posts', '150'),
              _buildInfoItem('Connections', '500'),
            ],
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _Details(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      alignment: Alignment.bottomLeft,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildButtonsRow() {
    return Column(
      children: [
        InkWell(
          onTap: () {
             controller.goToEditPageProfile();
          },
          child: Container(
            height: 35,
            padding: const EdgeInsets.only(left: 10),
            child: const Row(
              children: [
                Icon(Icons.edit),
                SizedBox(width: 10),
                Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Icons.arrow_forward, size: 30),
              ],
            ),
          ),
        ),
        _buildDivider(10),
        InkWell(
          onTap: () {
            controller.goToSeeAboutInfo();
          },
          child: Container(
            height: 35,
            padding: const EdgeInsets.only(left: 10),
            child: const Row(
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
        _buildDivider(10),
        InkWell(
          onTap: () {
            Get.to(NewPost());
          },
          child: Container(
            height: 35,
            padding: const EdgeInsets.only(left: 10),
            child: const Row(
              children: [
                Icon(Icons.post_add_outlined),
                SizedBox(width: 10),
                Text(
                  "Add New Post",
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

  Widget _buildDivider(double heightBetween) {
    return Column(
      children: [
        SizedBox(height: heightBetween),
        const Divider(
          color: Color.fromARGB(255, 194, 193, 193),
          thickness: 1.5,
        ),
      ],
    );
  }
}
