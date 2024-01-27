import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/SeeAboutInfo_Controller.dart';
import 'package:growify/global.dart';
import 'package:growify/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SeeAboutInfo extends StatelessWidget {
  SeeAboutInfo({super.key}) {}
  final SeeAboutInfoController controller = Get.put(SeeAboutInfoController());
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  String? profileImage;
  String? profileImageBytes;
  String? profileImageBytesName;
  String? profileImageExt;

  @override
  Widget build(BuildContext context) {
    var args = Get.arguments;
    List<Map<String, String>> educationLevels =
        args != null ? args['educationLevel'] : [].obs;
    controller.setEducationLevels(educationLevels);

    List<Map<String, String>> practicalExperiences =
        args != null ? args['practicalExperiences'] : [].obs;

    controller.setPracticalExperiences(practicalExperiences);

    RxMap personalDetails = args != null ? args['PersonalDetails'] : [].obs;

    controller.setpersonalData(personalDetails);
    print(personalDetails);
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "About Info",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 2, child: Container()),
            Expanded(
                flex: 4,
                child: Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes the position of shadow
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildPersonalDetails(controller),
                        _buildEducationList(controller),
                        _buildExperienceList(controller),
                      ],
                    ),
                  ),
                )),
            Expanded(flex: 2, child: Container()),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "About Info",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildPersonalDetails(controller),
              _buildEducationList(controller),
              _buildExperienceList(controller),
            ],
          ),
        ),
      );
    }
  }

 Future download(String url, String filename) async {
    print(url);
    print(filename);
    if (kIsWeb) {
      try {
        FileSaver.instance.saveFile(
            name: filename.split('.')[0],
            link: LinkDetails(link: url+"/"+filename),
            ext: 'pdf',
            mimeType: MimeType.pdf);
      } catch (err) {
        print(err);
      }
    } else {
      var savePath = '/storage/emulated/0/Download/$filename';
      var dio = Dio();
      dio.interceptors.add(LogInterceptor());
      try {
        var response = await dio.get(
          url + "/" + filename,
          //Received data with List<int>
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          ),
        );
        var file = File(savePath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        raf.writeFromSync(response.data);
        await raf.close();
        var playSound = true;
        Duration timeoutAfter = Duration(seconds: 5);
        await NotificationService.initializeNotification(playSound);
        await NotificationService.showNotification(
          title: "Growify",
          body: "file $filename downloaded successfully",
          chronometer: Duration.zero,
        );
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  ///
  Widget _buildPersonalDetails(SeeAboutInfoController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
      child: Obx(() {
        final personalData = controller.personalData.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 5),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromRGBO(14, 89, 108, 1),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 194, 193, 193),
                    thickness: 2.0,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, bottom: 10),
              child: Column(
                children: [
                  ...personalData.entries.map((entry) {
                    final String key = entry.key;
                    final dynamic value = entry.value;

                    return Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (key != "photo" &&
                              key != "coverImage" &&
                              key != "cv") ...[
                            Text(
                              '$key: ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            ),
                            Flexible(
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  value ?? "",
                                ),
                              ),
                            ),
                          ] else if (key == "cv") ...[
                            Text(
                              '$key: ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            ),
                            if (value != null && value != "") ...{
                              MaterialButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                onPressed: () async {
                                  await download(urlStarter, value);
                                },
                                textColor: Colors.blue,
                                child: const Text("Download"),
                              ),
                            }
                          ]
                        ],
                      ),
                      const SizedBox(height: 5),
                    ]);
                  }).toList(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

//
  Widget _buildEducationList(SeeAboutInfoController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 5),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Education Levels",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromRGBO(14, 89, 108, 1),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Color.fromARGB(255, 194, 193, 193),
                  thickness: 2.0,
                ),
              ],
            ),
          ),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.educationLevels.asMap().entries.map((entry) {
                final index = entry.key;
                final education = entry.value;

                return Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    ListTile(
                      title: Text(
                        '${education['School']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${education['Specialty']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.grey, width: 2.0)),
                            ),
                            padding: const EdgeInsets.only(
                                left: 5.0), // Adjust the left padding as needed
                            child: Text('${education['Description']}'),
                          ),
                          Text(
                              '${education['Start Date']} - ${education['End Date']}'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (index < controller.educationLevels.length - 1)
                      Container(
                        height: 1.5,
                        width: 300,
                        color: const Color.fromARGB(255, 194, 193, 193),
                      )
                  ],
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  ///
  Widget _buildExperienceList(SeeAboutInfoController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 100),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 5),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Work Experience",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromRGBO(14, 89, 108, 1),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Color.fromARGB(255, 194, 193, 193),
                  thickness: 2.0,
                ),
              ],
            ),
          ),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  controller.practicalExperiences.asMap().entries.map((entry) {
                final index = entry.key;
                final experience = entry.value;

                return Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    ListTile(
                      title: Text(
                        '${experience['Specialty']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (experience['isEmployee'] == "true") {
                                    controller.goToPage(experience['Company']!);
                                  }
                                },
                                child: Text(
                                  'At ${experience['Company']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: (experience['isEmployee'] == "true")
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              if (experience['isEmployee'] == "true")
                                Icon(
                                  Icons.verified,
                                  size: 20,
                                  color: Colors.blue,
                                )
                            ],
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.grey, width: 2.0)),
                            ),
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text('${experience['Description']}'),
                          ),
                          Text(
                              '${experience['Start Date']} - ${experience['End Date']}'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (index < controller.practicalExperiences.length - 1)
                      Container(
                        height: 1.5,
                        width: 300,
                        color: const Color.fromARGB(255, 194, 193, 193),
                      )
                  ],
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
