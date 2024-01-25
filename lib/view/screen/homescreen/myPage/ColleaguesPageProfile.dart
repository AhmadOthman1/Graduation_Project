import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:growify/controller/home/myPage_Controller/PageColleaguesProfile_controller.dart';
import 'package:growify/core/functions/alertbox.dart';

import 'package:growify/global.dart';

import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/chat/chatpagemessages.dart';
import 'package:growify/view/screen/homescreen/myPage/JobsPages/ShowCompanyJobs.dart';
import 'package:growify/view/screen/homescreen/myPage/colleaguesPageCalendar.dart';
import 'package:growify/view/screen/homescreen/myPage/seeAboutinfoPageColleagues.dart';
import 'dart:convert';

import 'package:growify/view/widget/homePage/posts.dart';

class ColleaguesPageProfile extends StatefulWidget {
  final userData;
  final following;
  const ColleaguesPageProfile(
      {super.key, required this.following, required this.userData});

  @override
  _ColleaguesPageProfileState createState() => _ColleaguesPageProfileState();
}

class _ColleaguesPageProfileState extends State<ColleaguesPageProfile> {
  final ColleaguesPageProfile_Controller controller =
      Get.put(ColleaguesPageProfile_Controller());

  late String? profileImage;
  late String? coverImage;
  late String? contactInfo;
  late String? firstName;

  final AssetImage defaultProfileImage =
      const AssetImage("images/profileImage.jpg");
  late ImageProvider<Object>? profileBackgroundImage;

  final AssetImage defaultCoverImage =
      const AssetImage("images/coverImage.jpg");
  late ImageProvider<Object> coverBackgroundImage;

  @override
  void initState() {
    super.initState();
    initializeUserData();
  }

  void initializeUserData() {
    print(widget.userData);
    controller.isFollowing = (widget.following == "F").obs;
    profileImage = widget.userData.photo;
    coverImage = widget.userData.coverImage;
    contactInfo = widget.userData.contactInfo ?? "";
    firstName = widget.userData.name;
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
      body: NestedScrollView(
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
                  if (!kIsWeb) _Deatalis("Details"),
                  if (!kIsWeb) _buildDivider(10),
                  if (!kIsWeb) _buildButtonsRow(),
                  if (!kIsWeb) _buildDivider(10),
                  if (!kIsWeb) _Deatalis("Posts"),
                  // Post(),
                ],
              ),
            )
          ];
        },
        body: kIsWeb
            ? Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _Deatalis("Details"),
                          _buildDivider(10),
                          _buildButtonsRow(),
                          _buildDivider(10),
                          // _buildDetails("Posts"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Post(username: widget.userData.id, isPage: true),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              )
            : Post(username: widget.userData.id, isPage: true),
        
        
        //Post(username: widget.userData.id, isPage: true),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$firstName',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 4,
              ),
              IconButton(
                  onPressed: () {
                    final Map<String, dynamic> pageInfo = {
                      'name': widget.userData.name,
                      'username': widget.userData.id,
                      'photo': widget.userData.photo,
                      'type': "P",
                    };
                    Get.to(ChatPageMessages(
                      data: pageInfo,
                    ));
                  },
                  icon: Icon(Icons.message)),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (String option) async {
                  var message = await controller.onMoreOptionSelected(
                    option,
                    widget.userData.id,
                  );
                  (message != null)
                      ? showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              title: 'Alert',
                              icon: Icons.error,
                              text: message,
                              buttonText: 'OK',
                            );
                          },
                        )
                      : null;
                  setState(() {});
                },
                itemBuilder: (BuildContext context) {
                  return controller.moreOptions.map((String option) {
                    return PopupMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          Text(
            '@${widget.userData.id}', // Replace with the actual username
            style: const TextStyle(fontSize: 16, color: Colors.blue),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Text(
                  '$contactInfo',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('Posts', widget.userData.postCount),
              _buildInfoItem('Followers', widget.userData.followCount),
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
            List userDataList = [
              {
                'name': widget.userData.name,
                'description': widget.userData.description,
                'address': widget.userData.address,
                'contactInfo': widget.userData.contactInfo,
                'country': widget.userData.country,
                'speciality': widget.userData.specialty,
                'pageType': widget.userData.pageType,
              },
            ];
            Get.to(CollaguesPageSeeAboutInfo(
              userData: userDataList,
            ));
          },
          child: Container(
            height: 35,
            padding: const EdgeInsets.only(left: 10),
            child:  Row(
              children: [
                Icon(Icons.more_horiz),
                SizedBox(width: 10),
                Text(
                  "See About info",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (!kIsWeb)
                Icon(Icons.arrow_forward, size: 30),
              ],
            ),
          ),
        ),
      if (!kIsWeb)  _buildDivider(10),
        InkWell(
          onTap: () {
            //controller.goToSeeAboutInfo();
            Get.to(ColleaguesPageCalender(
              pageId: widget.userData.id,
            ));
          },
          child: Container(
            height: 35,
            padding: const EdgeInsets.only(left: 10),
            child:  Row(
              children: [
                Icon(Icons.calendar_today_rounded),
                SizedBox(width: 10),
                Text(
                  "View Calendar",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (!kIsWeb)
                Icon(Icons.arrow_forward, size: 30),
              ],
            ),
          ),
        ),
    if (!kIsWeb)    _buildDivider(10),
        InkWell(
          onTap: () {
            //controller.goToSeeAboutInfo();
            Get.to(CompanyJobPage(
                pageId: widget.userData.id, image: widget.userData.photo));
          },
          child: Container(
            height: 35,
            padding: const EdgeInsets.only(left: 10),
            child:  Row(
              children: [
                Icon(Icons.more_horiz),
                SizedBox(width: 10),
                Text(
                  "View All Jobs",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (!kIsWeb)
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
    return Obx(() => SizedBox(
          width: 250,
          child: ElevatedButton(
            onPressed: () async {
              await controller.toggleFollow(widget.userData.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  controller.isFollowing.value ? Colors.grey : Colors.blue,
            ),
            child: Text(
              controller.isFollowing.value ? 'Following' : 'Follow',
              style: TextStyle(
                color: controller.isFollowing.value
                    ? Colors.black87
                    : Colors.white,
              ),
            ),
          ),
        ));
  }
}
