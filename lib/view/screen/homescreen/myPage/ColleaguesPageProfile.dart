import 'package:flutter/material.dart';
import 'package:growify/controller/home/myPage_Controller/PageColleaguesProfile_controller.dart';

import 'package:growify/global.dart';

import 'package:get/get.dart';
import 'dart:convert';

import 'package:growify/view/widget/homePage/posts.dart';

class ColleaguesPageProfile extends StatelessWidget {
  ColleaguesPageProfile({super.key, required this.userData}) {
    profileImage = '';
    coverImage = '';
    Description = userData[0]["Description"];
  }

  final ColleaguesPageProfile_Controller controller =
      Get.put(ColleaguesPageProfile_Controller());

  String? firstName;
  

  ////////////////////////////////
  final AssetImage defultprofileImage = const AssetImage("images/profileImage.jpg");
  String? profileImageBytes;
  String? profileImageBytesName;
  String? profileImageExt;
  String? profileImage;
  ImageProvider<Object>? profileBackgroundImage;
  String? coverImage;
  String? coverImageBytes;
  String? coverImageBytesName;
  String? coverImageExt;
  final AssetImage defultcoverImage = const AssetImage("images/coverImage.jpg");
  late ImageProvider<Object> coverBackgroundImage;
  String? Description;

  final List<Map<String, dynamic>> userData;

  @override
  Widget build(BuildContext context) {
    profileBackgroundImage = (profileImage != null && profileImage != "")
        ? Image.network("$urlStarter/" + profileImage!).image
        : defultprofileImage;

    coverBackgroundImage = (coverImage != null && coverImage != "")
        ? Image.network("$urlStarter/" + coverImage!).image
        : defultcoverImage;

    firstName; //=userData[0]["firstname"];
  
    final ss = firstName;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 50,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back, size: 30),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '${userData[0]["firstname"]} ',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 180),
                ],
              ),
            ),
            _buildCoverPhoto(),
            _buildProfileInfo(),
            _Deatalis("Details"),
            _buildDivider(10),
            _buildButtonsRow(),
            _buildDivider(10),
            _Deatalis("Posts"),
             Post(),
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
                : profileBackgroundImage,
          ),
          const SizedBox(height: 16),
          Text(
            '${userData[0]["firstname"]} ',
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
          const SizedBox(height: 16),
          _buildFollowButton(),
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

  Widget _Deatalis(String text) {
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
            controller.goToSeeAboutInfoColleagues();
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
        
      ],
    );
  }

  Widget _buildDivider(double HeigthBetween) {
    return Column(
      children: [
        SizedBox(height: HeigthBetween),
        const Divider(
          color: Color.fromARGB(255, 194, 193, 193),
          thickness: 1.5,
        ),
      ],
    );
  }


    Widget _buildFollowButton() {
    return Obx(() => ElevatedButton(
          onPressed: () {
            controller.isFollowing.toggle();
          },
          style: ElevatedButton.styleFrom(
            primary: controller.isFollowing.value ? Colors.grey : Colors.blue,
          ),
          child: Text(
            controller.isFollowing.value ? 'Following' : 'Follow',
            style: TextStyle(
              color: controller.isFollowing.value ? Colors.black87 : Colors.white,
            ),
          ),
        ));
  }
}
