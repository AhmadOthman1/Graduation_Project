import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowMembersController {

final RxList<String> moreOptions = <String>[
    'Delete',
  ].obs;
onMoreOptionSelected(
      String option ,String employeeUsername, String pageId) async {
      switch (option) {
        case 'Delete':
          return await deleteMember(pageId,employeeUsername);
          break;
      }
  }
 deleteMember(pageId, employeeUsername) async {
   
  }


  //////////////
  final List<Map<String, dynamic>> members = [];
  final AssetImage defaultProfileImage =
      const AssetImage("images/profileImage.jpg");

 
}
