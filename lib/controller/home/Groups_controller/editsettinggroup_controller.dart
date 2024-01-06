import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

abstract class EditGroupSettingsController extends GetxController {
  goToSettingsPgae();
  
}

/**
 List<int>? profileImageBytes;
  String? profileImageBytesName;
  String? profileImageExt;
  List<int>? coverImageBytes;
  String? coverImageBytesName;
  String? coverImageExt;
  List<int>? cvBytes ;
  String? cvName ;
  String? cvExt ;
 */
LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class EditGroupSettingsControllerImp extends EditGroupSettingsController {
  @override
  goToSettingsPgae() {
    Get.toNamed(AppRoute.settings);
  }

  // for the profile image
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;

  void updateProfileImage(
      String base64String, String imageName, String imageExt) {
    profileImageBytes.value = base64String;
    profileImageBytesName.value = imageName;
    profileImageExt.value = imageExt;
    update(); // This triggers a rebuild of the widget tree
  }

// for cover image
  final RxString coverImageBytes = ''.obs;
  final RxString coverImageBytesName = ''.obs;
  final RxString coverImageExt = ''.obs;

  void updateCoverImage(
      String base64String, String imageName, String imageExt) {
    coverImageBytes.value = base64String;
    coverImageBytesName.value = imageName;
    coverImageExt.value = imageExt;
    update();
  }



  // for dropDown country
  final RxBool isTextFieldEnabled11 = false.obs;
  final RxString country = ''.obs;
  final List<String> countryList = [
    "Palestine",
 
    "Zimbabwe"
  ];


  RxBool isTextFieldEnabled = false.obs;
  RxString textFieldText = ''.obs;
  RxBool isTextFieldEnabled2 = false.obs;
  RxString textFieldText2 = ''.obs;
  RxBool isTextFieldEnabled3 = false.obs;
  RxString textFieldText3 = ''.obs;
  


  @override
  postSaveChanges(
      ) async {
    var url = "$urlStarter/user/settingsChangeMainInfo";

    Map<String, dynamic> jsonData = {
      "email": GetStorage().read("loginemail"),
      "firstName": (isTextFieldEnabled == true) ? textFieldText.trim() : null,
      "lastName": (isTextFieldEnabled2 == true) ? textFieldText2.trim() : null,
      "address": (isTextFieldEnabled3 == true) ? textFieldText3.trim() : null,
      "country": (isTextFieldEnabled11 == true) ? country.trim() : null,
   
    
   
  };

  
}

  @override
  SaveChanges() {
    
  }
}
