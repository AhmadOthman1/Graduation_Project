import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class NewJobControllerImp extends GetxController {
  RxString postTitle = ''.obs;
  RxString postInterest = ''.obs;
  RxString postDescription = ''.obs;
  Rx<DateTime?> endDate = DateTime.now().obs;

  void updateEndDate(DateTime newEndDate) {
    endDate.value = newEndDate;
  }

  void updateTitle(String newTitle) {
    postTitle.value = newTitle;
  }

  void updateInterest(String newInterest) {
    postInterest.value = newInterest;
  }

  void updateDescription(String newDescription) {
    postDescription.value = newDescription;
  }

  postJob(pageId) async {
    var url = "$urlStarter/user/addNewJob";
    Map<String, dynamic> jsonData = {
      "pageId": pageId,
      "title": postTitle.value,
      "interest": postInterest.value,
      "description": postDescription.value,
      "endDate": endDate.value.toString(),
    };
    String jsonString = jsonEncode(jsonData);
    var response = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      postJob(pageId);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    } else {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return responseBody['message'];
    }
  }
}
