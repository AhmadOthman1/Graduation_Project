// final SeeAboutInfoColleaguesController controller = Get.put(SeeAboutInfoColleaguesController());

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/seeaboutInfoColleagues_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SeeAboutInfoColleagues extends StatelessWidget {
  SeeAboutInfoColleagues({super.key});

  final SeeAboutInfoColleaguesController controller =
      Get.put(SeeAboutInfoColleaguesController());
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

    // final Map<String, dynamic> arguments = Get.arguments;
    // final RxList<Map<String, String>> personalDetails =
    //   arguments['personalDetails'];
    // List<Map<String, String>> educationLevel =
//args != null ? args['educationLevel'] : [];
    // final RxList<Map<String, String>> practicalExperiences =
    // arguments['practicalExperiences'];

    // controller.setpersonalData(personalDetails);

    // controller.setPracticalExperiences(practicalExperiences);
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
  /*
Future<void> downloadFromWeb(String url, String filename) async {
    final html.AnchorElement anchor = html.AnchorElement(href: url)
      ..target = 'web'
      ..download = filename;

    final Uint8List bytes = await _fetchBytes(url);
    final html.Blob blob = html.Blob([bytes]);

    final urlBlob = html.Url.createObjectUrlFromBlob(blob);
    anchor.href = urlBlob;

    final body = html.querySelector('body');
    if (body != null) {
      body.children.add(anchor);
    }

    anchor.click();

    html.Url.revokeObjectUrl(urlBlob);
  }

  Future<Uint8List> _fetchBytes(String url) async {
    final html.HttpRequest request =
        await html.HttpRequest.request(url, responseType: 'arraybuffer');
    if (request.status == 200) {
      final ByteBuffer byteBuffer = request.response;
      return Uint8List.fromList(byteBuffer.asUint8List());
    } else {
      throw Exception('Failed to load data: ${request.statusText}');
    }
  }
  */

  ///
  Widget _buildPersonalDetails(SeeAboutInfoColleaguesController controller) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: Text((value ?? "").toString()),
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
                                  download(urlStarter, value);
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
  Widget _buildEducationList(SeeAboutInfoColleaguesController controller) {
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
  Widget _buildExperienceList(SeeAboutInfoColleaguesController controller) {
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
