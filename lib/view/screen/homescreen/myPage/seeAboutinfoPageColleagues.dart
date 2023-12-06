import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/SeeAboutInfo_Controller.dart';
import 'package:growify/global.dart';
import 'package:url_launcher/url_launcher.dart';

class CollaguesPageSeeAboutInfo extends StatelessWidget {
  CollaguesPageSeeAboutInfo({super.key}) {
    
  }
  final SeeAboutInfoController controller = Get.put(SeeAboutInfoController());
  final AssetImage defultprofileImage = const AssetImage("images/profileImage.jpg");
  String? profileImage;
  String? profileImageBytes;
  String? profileImageBytesName;
  String? profileImageExt;

  @override
  Widget build(BuildContext context) {
    var args = Get.arguments;


 

    RxMap personalDetails = args != null ? args['PersonalDetails'] : [].obs;

    controller.setpersonalData(personalDetails);
    print(personalDetails);

  
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
                        children: [
                          if (key != "photo" &&
                              key != "coverImage" &&
                              key != "cv") ...[
                            Text(
                              '$key: ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            ),
                            Text(value ?? ""),
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
                                  if (kIsWeb) {
                                    var url = "$urlStarter/" + value;
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
                                    download("$urlStarter/" + value, value);
                                  }
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


  ///

}
