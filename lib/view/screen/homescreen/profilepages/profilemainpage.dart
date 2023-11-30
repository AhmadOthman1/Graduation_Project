import 'package:flutter/material.dart';

import 'package:growify/controller/home/profileMainPage_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/settings/settings.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:growify/view/widget/homePage/posts.dart';

class ProfileMainPage extends StatelessWidget {
  ProfileMainPage({super.key, required this.userData}) {
    profileImage = (userData[0]["photo"] == null) ? "" : userData[0]["photo"];
    coverImage =
        (userData[0]["coverImage"] == null) ? "" : userData[0]["coverImage"];
    Bio = (userData[0]["bio"] == null) ? "" : userData[0]["bio"];
  }

  final ProfileMainPageControllerImp controller =
      Get.put(ProfileMainPageControllerImp());


  final List<Map<String, dynamic>> userData;
  String? firstName;
  String? lastName;
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
  String? Bio;

  @override
  Widget build(BuildContext context) {
    //final List<Map<String, dynamic>> userData;

    // Extract 'user' from arguments

    profileBackgroundImage = (profileImage != null && profileImage != "")
        ? Image.network("$urlStarter/" + profileImage!).image
        : defultprofileImage;

    coverBackgroundImage = (coverImage != null && coverImage != "")
        ? Image.network("$urlStarter/" + coverImage!).image
        : defultcoverImage;

    firstName; //=userData[0]["firstname"];
    lastName;
    final ss = firstName;

    //String userName
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCoverPhoto(),
            _buildProfileInfo(),
            _Deatalis("The Details"),
            _buildDivider(10),
            _buildButtonsRow(),
            _buildDivider(10),
            _Deatalis("Your Posts"),
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

          //NetworkImage('${urlStarter}/${userData[0]["coverImage"]}'),
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
          const SizedBox(height: 16),
          Text(
            '${userData[0]["firstname"]} ${userData[0]["lastname"]}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '@${userData[0]["username"]}', // Replace with the actual username
            style: const TextStyle(fontSize: 16, color: Colors.blue),
          ),
          
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Text('$Bio',
                 style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.grey[700])
                 ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('Posts', '150'),
              _buildInfoItem('Followers', '500'),
              _buildInfoItem('Following', '300'),
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
            Get.to(Settings());
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
            ///// go to about info
            // Get.to(SeeAboutInfo());
            //  controller.goToAboutInfo();
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

  
}
