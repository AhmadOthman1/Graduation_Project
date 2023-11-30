import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/ColleaguesProfile_controller.dart';

import 'package:growify/global.dart';
import 'dart:convert';

import 'package:growify/view/widget/homePage/posts.dart';

class ColleaguesProfile extends StatelessWidget {
  ColleaguesProfile({super.key, required this.userData}) {
    profileImage = (userData[0]["photo"] == null) ? "" : userData[0]["photo"];
    coverImage =
        (userData[0]["coverImage"] == null) ? "" : userData[0]["coverImage"];
    Bio = (userData[0]["bio"] == null) ? "" : userData[0]["bio"];

    // get from database

   // controller.result.value= Follow/Following/Requested
  }
  final ColleaguesProfileControllerImp controller =
      Get.put(ColleaguesProfileControllerImp());

 
  final List<Map<String, dynamic>> userData;
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
  String? Bio;
  ///////////
  String? Follow;
  String? Following;
  String? Requested;
  String? Result;

  @override
  Widget build(BuildContext context) {
    Follow = 'Follow';
    Requested='Requested';
    Following='Following';

    Result = Requested;

    profileBackgroundImage = (profileImage != null && profileImage != "")
        ? Image.network("$urlStarter/" + profileImage!).image
        : defultprofileImage;

    coverBackgroundImage = (coverImage != null && coverImage != "")
        ? Image.network("$urlStarter/" + coverImage!).image
        : defultcoverImage;

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
                      '${userData[0]["firstname"]} ${userData[0]["lastname"]}',
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 180),
                ],
              ),
            ),
            const Divider(
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
            const Post(),
            
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
          const SizedBox(height: 16),
          Text(
            '${userData[0]["firstname"]} ${userData[0]["lastname"]}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '@${userData[0]["username"]}', // Replace with the actual username
            style: const TextStyle(fontSize: 16, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('Posts', '23'),
              _buildInfoItem('Followers', '167'),
              _buildInfoItem('Following', '243'),
            ],
          ),
          GetBuilder<ColleaguesProfileControllerImp>(
  builder: (controller) =>Container(
    margin: const EdgeInsets.only(top: 10),
    child: MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 140),
      onPressed: () {
        controller.toggleResult();
      },
      color: controller.result.value == 'Follow'
          ? const Color.fromARGB(255, 85, 191, 218)
          : Colors.grey,
      textColor: Colors.white,
      child: Text(controller.result.value),
    ),
  ),
)
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

  Widget _buildBio() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
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
      margin: const EdgeInsets.only(left: 5),
      alignment: Alignment.bottomLeft,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
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

  Widget _buildButtonsRow() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            controller.goToAboutInfo();
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

 
}