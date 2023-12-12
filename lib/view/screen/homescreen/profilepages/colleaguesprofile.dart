import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/ColleaguesProfile_controller.dart';
import 'package:growify/core/functions/alertbox.dart';

import 'package:growify/global.dart';
import 'dart:convert';

import 'package:growify/view/widget/homePage/posts.dart';

bool isDeleteButtonVisible = false;

class ColleaguesProfile extends StatelessWidget {
  ColleaguesProfile({super.key, required this.userData}) {
    profileImage = (userData[0]["photo"] == null) ? "" : userData[0]["photo"];
    coverImage =
        (userData[0]["coverImage"] == null) ? "" : userData[0]["coverImage"];
    Bio = (userData[0]["bio"] == null) ? "" : userData[0]["bio"];

    switch (userData[0]["connection"]) {
      case 'C':
        controller.result.value = "Connected";
        isDeleteButtonVisible = false;
        break;
      case 'R':
        controller.result.value = "Requested";
        isDeleteButtonVisible = false;
        break;
      case 'S':
        controller.result.value = "Accept";
        isDeleteButtonVisible = true;
        break;
      case 'N':
        controller.result.value = "Connect";
        isDeleteButtonVisible = false;
        break;
    }

    // get from database

    // controller.result.value= Follow/Following/Requested
  }
  final ColleaguesProfileControllerImp controller =
      Get.put(ColleaguesProfileControllerImp());

  final List<Map<String, dynamic>> userData;
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
  ///////////

  @override
  Widget build(BuildContext context) {
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
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
            _buildProfileInfo(context),
            _Deatalis("Details"),
            _buildDivider(10),
            _buildButtonsRow(),
            _buildDivider(10),
            _Deatalis("Posts"),
           //  Post(),
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
                                            userData[0]["username"]);
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
                                        .sendRemoveReq(userData[0]["username"]);
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
                            .sendAcceptConnectReq(userData[0]["username"]);
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
                            .sendConnectReq(userData[0]["username"]);
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
                  flex: isDeleteButtonVisible ? 1 : 0,
                  child: Visibility(
                    visible: isDeleteButtonVisible,
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
                                              userData[0]["username"]);
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
            controller.goToAboutInfo(userData[0]["username"]);
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
