import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowGroupAdminsController {

final RxList<String> moreOptions = <String>[
    'Delete',
  ].obs;
onMoreOptionSelected(
      String option ,String employeeUsername, String pageId) async {
      switch (option) {
        case 'Delete':
          return await deleteAdmin(pageId,employeeUsername);
          break;
      }
  }
 deleteAdmin(pageId, employeeUsername) async {
   
  }



  //////////////////////////
  final List<Map<String, dynamic>> admins = [
   
  ];

  final AssetImage defaultProfileImage =
      const AssetImage("images/profileImage.jpg");
}