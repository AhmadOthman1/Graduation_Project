import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/controller/home/network_controller/showcolleagues_controller.dart';
import 'package:growify/global.dart';

class ColleaguesPage extends StatefulWidget {
  const ColleaguesPage({Key? key}) : super(key: key);

  @override
  _ColleaguesPage createState() => _ColleaguesPage();
}

class _ColleaguesPage extends State<ColleaguesPage> {
  final ShowColleaguesControllerImp controller =
      Get.put(ShowColleaguesControllerImp());

  // late RxList<Map<String, dynamic>> localColleagues;

  @override
  void initState() {
    controller.localColleagues =
        RxList<Map<String, dynamic>>.from(Get.arguments['colleagues']);

    controller.localColleagues.sort((a, b) => a['name'].compareTo(b['name']));
    super.initState();
  }

  bool isLoading = false;

  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  String? profileImageBytes;
  String? profileImageBytesName;
  String? profileImageExt;
  String? profileImage;
  ImageProvider<Object>? profileBackgroundImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    "Colleagues",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                var currentPos = scrollInfo.metrics.pixels;
                var maxPos = scrollInfo.metrics.maxScrollExtent;

                if (!isLoading && currentPos == maxPos) {
                  setState(() {
                    isLoading =
                        true; // Set loading to true to avoid multiple requests
                    controller.Upage++;
                  });

                  controller.getColleaguesfromDataBase().then((result) async {
                    if (result != null && result.isNotEmpty) {
                      await Future.delayed(Duration(
                          seconds:
                              1)); // to solve the problem when the user reach the bottom of the page1, it fetch page 3,4,5...etc.
                      setState(() {
                        isLoading =
                            false; // Reset loading when the data is fetched
                      });
                      print(isLoading);
                    }
                  });
                }
                return false;
              },
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.localColleagues.length,
                  itemBuilder: (context, index) {
                    final colleague = controller.localColleagues[index];
                    profileImage =
                        (colleague['image'] == null) ? "" : colleague['image'];
                    profileBackgroundImage = (profileImage != null &&
                            profileImage != "")
                        ? Image.network("$urlStarter/" + profileImage!).image
                        : defultprofileImage;

                    return Column(
                      children: [
                        ListTile(
                          leading: InkWell(
                            onTap: () {
                              //   Get.to(ColleaguesProfile());
                            },
                            child: CircleAvatar(
                              backgroundImage:
                                  controller.profileImageBytes.isNotEmpty
                                      ? MemoryImage(base64Decode(
                                          controller.profileImageBytes.value))
                                      : profileBackgroundImage,
                            ),
                          ),
                          title: Text(colleague['name']),
                          subtitle: Text(colleague['jobTitle']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Icon(Icons.arrow_forward)],
                          ),
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 194, 193, 193),
                          thickness: 2.0,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
