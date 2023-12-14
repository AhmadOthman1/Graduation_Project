import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/ColleaguesProfile_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/global.dart';
import 'dart:convert';

import 'package:growify/view/widget/homePage/posts.dart';

class ColleaguesProfile extends StatefulWidget {
  late ColleaguesProfileControllerImp controller;
  final List<Map<String, dynamic>> userData;
  

  ColleaguesProfile({super.key, required this.userData});

  @override
  _ColleaguesProfileState createState() => _ColleaguesProfileState();
}

class _ColleaguesProfileState extends State<ColleaguesProfile> {
   late ColleaguesProfileControllerImp controller;
 // final ColleaguesProfileControllerImp controller =
  //    Get.put(ColleaguesProfileControllerImp());

  @override
  void initState() {
    super.initState();
    controller = Get.put(ColleaguesProfileControllerImp());
    
  }

  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");

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
    profileBackgroundImage = (profileImage != null && profileImage != "")
        ? Image.network("$urlStarter/" + profileImage!).image
        : defultprofileImage;

    coverBackgroundImage = (coverImage != null && coverImage != "")
        ? Image.network("$urlStarter/" + coverImage!).image
        : defultcoverImage;

    return Scaffold(
       
      body: NestedScrollView(
       headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverList(
        delegate: SliverChildListDelegate(
          [
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
                      '${widget.userData[0]["firstname"]} ',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 180),
                ],
              ),
            ),
            
            _buildCoverPhoto(),
            _buildProfileInfo(context),
              _Deatalis("Details"),
              _buildDivider(10),
              _buildButtonsRow(),
              _buildDivider(10),
              _Deatalis("Posts"),
            // Post(),
          ],
        ),)
          ];
        },
         body: Post(),
      ),
    );
  }

   Widget _buildCoverPhoto() {
    String coverImage = widget.userData[0]["coverImage"] ?? "";
    ImageProvider<Object> coverBackgroundImage =
        (coverImage.isNotEmpty) ? Image.network("$urlStarter/$coverImage").image : const AssetImage("images/coverImage.jpg");

    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: controller.coverImageBytes.isNotEmpty
              ? MemoryImage(base64Decode(controller.coverImageBytes.value!))
              : coverBackgroundImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

   Widget _buildProfileInfo(context) {
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
            '${widget.userData[0]["firstname"]} ${widget.userData[0]["lastname"]}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '@${widget.userData[0]["username"]}', // Replace with the actual username
            style: const TextStyle(fontSize: 16, color: Colors.blue),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Text('$Bio',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[700])),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('Posts', '23'),
              _buildInfoItem('Connections', '167'),
            ],
          ),
          GetBuilder<ColleaguesProfileControllerImp>(
            builder: (controller) => Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(children: [
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    //padding:const EdgeInsets.symmetric(vertical: 13, horizontal: 140),
                    onPressed: () async {
                      if (controller.result.value == "Connected") {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Remove the connection'),
                              content: Text(
                                  'Are you sure you want to remove this user from your connection?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    var message =
                                        await controller.sendRemoveConnection(
                                            widget.userData[0]["username"]);
                                    Navigator.of(context).pop();
                                    (message != null)
                                        ? showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomAlertDialog(
                                                title: 'Error',
                                                icon: Icons.error,
                                                text: message,
                                                buttonText: 'OK',
                                              );
                                            },
                                          )
                                        : null;
                                  },
                                  child: Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('No'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      if (controller.result.value == "Requested") {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Remove the request'),
                              content: Text(
                                  'Are you sure you want to remove the request?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    var message = await controller
                                        .sendRemoveReq(widget.userData[0]["username"]);
                                    Navigator.of(context).pop();
                                    (message != null)
                                        ? showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomAlertDialog(
                                                title: 'Error',
                                                icon: Icons.error,
                                                text: message,
                                                buttonText: 'OK',
                                              );
                                            },
                                          )
                                        : null;
                                  },
                                  child: Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('No'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      if (controller.result.value == "Accept") {
                        var message = await controller
                            .sendAcceptConnectReq(widget.userData[0]["username"]);
                        (message != null)
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomAlertDialog(
                                    title: 'Error',
                                    icon: Icons.error,
                                    text: message,
                                    buttonText: 'OK',
                                  );
                                },
                              )
                            : null;
                      }
                      if (controller.result.value == "Connect") {
                        var message = await controller
                            .sendConnectReq(widget.userData[0]["username"]);
                        (message != null)
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomAlertDialog(
                                    title: 'Error',
                                    icon: Icons.error,
                                    text: message,
                                    buttonText: 'OK',
                                  );
                                },
                              )
                            : null;
                      }
                      //controller.toggleResult();
                    },
                    color: controller.result.value == 'Connect'
                        ? const Color.fromARGB(255, 85, 191, 218)
                        : Colors.grey[800],
                    textColor: Colors.white,
                    child: Text(controller.result.value),
                  ),
                ),
                Expanded(
                  flex: controller. isDeleteButtonVisible ? 1 : 0,
                  child: Visibility(
                    visible: controller.isDeleteButtonVisible,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      //padding: const EdgeInsets.symmetric( vertical: 13, horizontal: 140),
                      onPressed: () {
                        if (controller.result.value == "Accept") {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Remove the request'),
                                content: Text(
                                    'Are you sure you want to remove the request?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      var message =
                                          await controller.sendDeleteReq(
                                              widget.userData[0]["username"]);
                                      Navigator.of(context).pop();
                                      (message != null)
                                          ? showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CustomAlertDialog(
                                                  title: 'Error',
                                                  icon: Icons.error,
                                                  text: message,
                                                  buttonText: 'OK',
                                                );
                                              },
                                            )
                                          : null;
                                    },
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('No'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        controller.toggleResult();
                      },
                      color: Colors.grey,
                      textColor: Colors.white,
                      child: Text("Delete"),
                    ),
                  ),
                ),
              ]),
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
            controller.goToAboutInfo(widget.userData[0]["username"]);
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
