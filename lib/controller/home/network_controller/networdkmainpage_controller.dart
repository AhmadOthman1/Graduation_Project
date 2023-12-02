
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/Networkspages/showcolleagues.dart';

class NetworkMainPageControllerImp extends GetxController {
  final RxList<Map<String, dynamic>> colleagues = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    // Initialize the RxList
    colleagues.assignAll([
      {
        'name': 'Islam Aws',
        'jobTitle': 'UI Designer',
        'image': 'images/islam.jpeg',

      },
      {
        'name': 'Obaida Aws',
        'jobTitle': 'Software Engineer',
        'image': 'images/obaida.jpeg',
  
      },
      // Add more colleagues as needed
    ]);
    super.onInit();
  }

  goToShowMyColleagues() {
    Get.to(ColleaguesPage(), arguments: {
      'colleagues': colleagues,
    });
  }
}