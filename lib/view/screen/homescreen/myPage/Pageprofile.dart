import 'package:flutter/material.dart';
import 'package:growify/controller/home/myPage_Controller/PageProfile_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/Groups/ShowAllGroup.dart';
import 'package:growify/view/screen/homescreen/JobsPages/addnewjob.dart';
import 'package:growify/view/screen/homescreen/JobsPages/showAllMyPageJobs.dart';
import 'package:growify/view/screen/homescreen/NewPost/newpost.dart';
import 'package:growify/view/screen/homescreen/myPage/Admins/ShowAllAdmins.dart';
import 'package:growify/view/screen/homescreen/myPage/Employees/ShowAllEmployees.dart';
import 'package:growify/view/screen/homescreen/myPage/Employees/addEmployee.dart';
import 'package:growify/view/screen/homescreen/myPage/seeAboutInfoMyPage.dart';
import 'package:growify/view/widget/homePage/posts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PageProfile extends StatefulWidget {
  final userData;
  final isAdmin;
  const PageProfile({Key? key, required this.isAdmin , required this.userData}) : super(key: key);

  @override
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  final PageProfileController controller = Get.put(PageProfileController());

  late String? profileImage;
  late String? coverImage;
  late String? Description;
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
    profileImage = widget.userData.photo;
    coverImage = widget.userData.coverImage;
    Description = widget.userData.description ?? "";
    firstName = widget.userData.name;
    GetStorage().write("photopage", widget.userData.photo);
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
        body: Post(isAdmin : widget.isAdmin, username: widget.userData.id, isPage: true),
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
                  '$Description',
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
            Get.to(ShowAdmins(pageId: widget.userData.id));
          },
          child: Container(
            height: 35,
            padding: const EdgeInsets.only(left: 10),
            child: const Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 10),
                Text(
                  "Show Admins",
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
            Get.to(ShowEmployees(pageId: widget.userData.id));
          },
          child: Container(
            height: 35,
            padding: const EdgeInsets.only(left: 10),
            child: const Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 10),
                Text(
                  "Show Employees",
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
           Get.to(GroupPage(pageId : widget.userData.id));
          },
          child: Container(
            height: 35,
            padding: const EdgeInsets.only(left: 10),
            child: const Row(
              children: [
                Icon(Icons.diversity_3),
                SizedBox(width: 10),
                Text(
                  "Show Groups",
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
            controller.goToEditPageProfile(widget.userData);
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

            Get.to(MyPageSeeAboutInfo(userData: userDataList));
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
            //controller.goToSeeAboutInfo();
            Get.to(MyJobPage(pageId: widget.userData.id));
          },
          child: Container(
            height: 35,
            padding: const EdgeInsets.only(left: 10),
            child: const Row(
              children: [
                Icon(Icons.more_horiz),
                SizedBox(width: 10),
                Text(
                  "View All Jobs",
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
            Get.to(NewPost(
                profileImage: profileImage,
                isPage: true,
                pageId: widget.userData.id));
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
