import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/ColleaguesProfile_controller.dart';
import 'package:growify/controller/home/chats_controller/chatmainpage_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/chat/chatpagemessages.dart';
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

  @override
  void initState() {
    super.initState();
    controller = Get.put(ColleaguesProfileControllerImp());
    final userUsername = widget.userData[0]["username"];
    final userFirstname = widget.userData[0]["firstname"];
    final userLastname = widget.userData[0]["lastname"];
    final userPhoto = widget.userData[0]["photo"];
    Map<String, dynamic> userMap = {
      'name': '$userFirstname $userLastname',
      'username': userUsername,
      'photo': userPhoto,
      'type': 'U'
    };
    controller.colleaguesmessages.assign(userMap);
  }

  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");

  String? profileImageBytes;
  String? profileImageBytesName;
  String? profileImageExt;

  String? coverImageBytes;
  String? coverImageBytesName;
  String? coverImageExt;

  final AssetImage defultcoverImage = const AssetImage("images/coverImage.jpg");

  String? Bio;

  @override
  Widget build(BuildContext context) {
    switch (widget.userData[0]["connection"]) {
      case 'C':
        controller.result.value = "Connected";
        controller.isDeleteButtonVisible = false;
        break;
      case 'R':
        controller.result.value = "Requested";
        controller.isDeleteButtonVisible = false;
        break;
      case 'S':
        controller.result.value = "Accept";
        controller.isDeleteButtonVisible = true;
        break;
      case 'N':
        controller.result.value = "Connect";
        controller.isDeleteButtonVisible = false;
        break;
    }

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
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildProfileInfo(context),
                  _Deatalis("Details"),
                  _buildDivider(10),
                  _buildButtonsRow(),
                  _buildDivider(10),
                  _Deatalis("Posts"),
                  // Post(),
                ],
              ),
            )
          ];
        },
        body: Post(/*username: 'AhmadOthman'*/),
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

  Widget _buildProfileInfo(context) {
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
                : profileBackgroundImage, // Replace with your default photo URL
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 3,),
              Text(
                '${widget.userData[0]["firstname"]} ${widget.userData[0]["lastname"]}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              InkWell(
                      onTap: () {
                        controller.goToChatMessage();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, left: 3),
                        child: const Icon(
                          Icons.message_rounded,
                          size: 30,
                        ),
                      ),
                    ),
            ],
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
                Text(Bio != null ? '$Bio' : "",
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
                              title: const Text('Remove the connection'),
                              content: const Text(
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
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'),
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
                              title: const Text('Remove the request'),
                              content: const Text(
                                  'Are you sure you want to remove the request?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    var message =
                                        await controller.sendRemoveReq(
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
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      if (controller.result.value == "Accept") {
                        var message = await controller.sendAcceptConnectReq(
                            widget.userData[0]["username"]);
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
                  flex: controller.isDeleteButtonVisible ? 1 : 0,
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
                                title: const Text('Remove the request'),
                                content: const Text(
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
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No'),
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
                      child: const Text("Delete"),
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
