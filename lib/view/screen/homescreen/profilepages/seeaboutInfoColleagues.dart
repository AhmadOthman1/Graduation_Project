// final SeeAboutInfoColleaguesController controller = Get.put(SeeAboutInfoColleaguesController());


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/SeeAboutInfo_Controller.dart';
import 'package:growify/controller/home/seeaboutInfoColleagues_controller.dart';
import 'package:growify/global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SeeAboutInfoColleagues extends StatelessWidget {
  SeeAboutInfoColleagues({super.key}){

  }

  final SeeAboutInfoColleaguesController controller = Get.put(SeeAboutInfoColleaguesController());
  final AssetImage defultprofileImage = AssetImage("images/profileImage.jpg");
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Info",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
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

  Future download(String url, String filename) async {
    var savePath = '/storage/emulated/0/Download/$filename';
    var dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      var response = await dio.get(
        url,
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
    } catch (e) {
      debugPrint(e.toString());
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
      margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
      child: Obx(() {
        final personalData = controller.personalData.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 5),
              child: Column(
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
              margin: EdgeInsets.only(left: 10, bottom: 10),
              child: Column(
                children: [
                  ...personalData.entries.map((entry) {
                    final String key = entry.key;
                    final dynamic value = entry.value;

                    return Column(children: [
                      Row(
                        children: [
                          if (key != "photo" &&
                              key != "coverImage" &&
                              key != "cv") ...[
                            Text(
                              '$key: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            ),
                            Text(value ?? ""),
                          ] else if (key == "cv") ...[
                            Text(
                              '$key: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            ),
                            if (value != null && value != "") ...{
                              MaterialButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                onPressed: () async {
                                  if (kIsWeb) {
                                    var url = urlStarter + "/" + value;
                                    if (await canLaunch(url)) {
                                      await launch(
                                        url,
                                        headers: {
                                          "Content-Type": "application/pdf",
                                          "Content-Disposition": "inline"
                                        },
                                      );
                                      print("browser url");
                                      print(url);
                                    } else {
                                      // can't launch url, there is some error
                                      throw "Could not launch $url";
                                    }
                                  } else {
                                    download(urlStarter + "/" + value, value);
                                  }
                                },
                                textColor: Colors.blue,
                                child: Text("Download"),
                              ),
                            }
                          ]
                        ],
                      ),
                      SizedBox(height: 5),
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
      margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 5),
            child: Column(
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
                    SizedBox(
                      height: 5,
                    ),
                    ListTile(
                      title: Text(
                        '${education['School']}',
                        style: TextStyle(
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
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.grey, width: 2.0)),
                            ),
                            padding: EdgeInsets.only(
                                left: 5.0), // Adjust the left padding as needed
                            child: Text('${education['Description']}'),
                          ),
                          Text(
                              '${education['Start Date']} - ${education['End Date']}'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (index < controller.educationLevels.length - 1)
                      Container(
                        height: 1.5,
                        width: 300,
                        color: Color.fromARGB(255, 194, 193, 193),
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
      margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 100),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 5),
            child: Column(
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
                    SizedBox(
                      height: 5,
                    ),
                    ListTile(
                      title: Text(
                        '${experience['Specialty']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${experience['Company']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.grey, width: 2.0)),
                            ),
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text('${experience['Description']}'),
                          ),
                          Text(
                              '${experience['Start Date']} - ${experience['End Date']}'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (index < controller.practicalExperiences.length - 1)
                      Container(
                        height: 1.5,
                        width: 300,
                        color: Color.fromARGB(255, 194, 193, 193),
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
