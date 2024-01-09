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


LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class EditGroupSettingsControllerImp extends EditGroupSettingsController {
  @override
  goToSettingsPgae() {
    Get.toNamed(AppRoute.settings);
  }

  
  final RxBool isTextFieldEnabledParentGroup = false.obs;
  final RxString parentNode = ''.obs;



  RxBool isTextFieldEnabledGroupId = false.obs;
  RxString textFieldText = ''.obs;
  RxBool isTextFieldEnabledDescription = false.obs;
  RxString textFieldText2 = ''.obs;
  RxBool isTextFieldEnabledGroupName = false.obs;
  RxString textFieldText3 = ''.obs;
  ////////////////
  RxBool isTextFieldEnabledCheckBox = false.obs;
  RxBool isTextFieldValueCheckBox = false.obs;


  @override
  postSaveChanges( int pageId,int grpoupId

   ) async {
    var url = "$urlStarter/user/settingsChangeMainInfo";

    Map<String, dynamic> jsonData = {
      "email": GetStorage().read("loginemail"),
      "description": (isTextFieldEnabledDescription == true) ? textFieldText2.trim() : null,
      "name": (isTextFieldEnabledGroupName == true) ? textFieldText3.trim() : null,
      "parentNode": (isTextFieldEnabledParentGroup == true) ? parentNode : null,
      
   
    

   
  };

  
}

  @override
  SaveChanges() {
    
  }
}
