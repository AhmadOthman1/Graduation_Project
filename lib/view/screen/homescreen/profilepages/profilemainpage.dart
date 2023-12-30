import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/profileMainPage_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/NewPost/newpost.dart';
import 'package:growify/view/screen/homescreen/settings/settings.dart';
import 'package:growify/view/widget/homePage/posts.dart';

class ProfileMainPage extends StatefulWidget {
  final List<Map<String, dynamic>> userData;
  final int userPostCount;
  final int userConnectionsCount;

  const ProfileMainPage({
    Key? key,
    required this.userData,
    required this.userPostCount,
    required this.userConnectionsCount,
  }) : super(key: key);

  @override
  _ProfileMainPageState createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  late Post postController = Post();
  late ProfileMainPageControllerImp controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileMainPageControllerImp());
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      print("Reached the end of the page");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    /*  appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 5, 3, 3)),
      ),*/
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [

            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildCoverPhoto(),
              ),
            ),
            
            SliverToBoxAdapter(
              child: Column(
                children: [              
                  _buildProfileInfo(),
                  _buildDetails("Details"),
                  _buildDivider(10),
                  _buildButtonsRow(),
                  _buildDivider(10),
                  _buildDetails("Posts"),
                ],
              ),
            ),
           
          ];
        },
        body: Post(username: widget.userData[0]["username"]),
      ),
    );
  }

  Widget _buildCoverPhoto() {
    String coverImage = widget.userData[0]["coverImage"] ?? "";
    ImageProvider<Object> coverBackgroundImage = (coverImage.isNotEmpty)
        ? Image.network("$urlStarter/$coverImage").image
        : const AssetImage("images/coverImage.jpg");

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
    String profileImage = widget.userData[0]["photo"] ?? "";
    ImageProvider<Object> profileBackgroundImage = (profileImage.isNotEmpty)
        ? Image.network("$urlStarter/$profileImage").image
        : const AssetImage("images/profileImage.jpg");

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
            '${widget.userData[0]["firstname"]} ${widget.userData[0]["lastname"]}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '@${widget.userData[0]["username"]}',
            style: const TextStyle(fontSize: 16, color: Colors.blue),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Text(
                  widget.userData[0]["bio"] ?? "",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('Posts', widget.userPostCount.toString()),
              _buildInfoItem('Connections', widget.userConnectionsCount.toString()),
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

  Widget _buildDetails(String text) {
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


