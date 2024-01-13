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
  postSaveChanges(int groupId) async {
    var url = "$urlStarter/user/editGroupInfo";

    Map<String, dynamic> jsonData = {
      "groupId": groupId,
      "description": (isTextFieldEnabledDescription == true)
          ? textFieldText2.trim()
          : null,
      "name":
          (isTextFieldEnabledGroupName == true) ? textFieldText3.trim() : null,
      "memberCanSendMessages": (isTextFieldEnabledCheckBox == true)
          ? isTextFieldValueCheckBox.toString()
          : null,
    };
    print(isTextFieldValueCheckBox.toString());

    print(isTextFieldValueCheckBox.toString());
    print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
    String jsonString = jsonEncode(jsonData);
    int contentLength = utf8.encode(jsonString).length;
    var responce = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    if (responce.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      postSaveChanges(groupId);
      return;
    } else if (responce.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    print(responce.statusCode);
    if (responce.statusCode == 409 || responce.statusCode == 500) {
      var resbody = jsonDecode(responce.body);
      return resbody['message'];
    } else if (responce.statusCode == 200) {
      var resbody = jsonDecode(responce.body);
      isTextFieldEnabledDescription.value=false;
      isTextFieldEnabledGroupName.value=false;
      isTextFieldEnabledCheckBox.value=false;
      Get.offNamed(AppRoute.homescreen);

    }
  }

  @override
  SaveChanges() {}
}
