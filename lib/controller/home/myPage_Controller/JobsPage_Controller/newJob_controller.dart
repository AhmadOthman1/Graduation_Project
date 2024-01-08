import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class NewJobControllerImp extends GetxController {
   RxList<String> selectedItems = <String>[].obs;
    
 RxList<String> items = RxList<String>([
  'Accounting',
  'Agricultural Engineering',
  'American Studies',
  'Anesthesia and Technical Resuscitation',
  'Animal Production and Animal Health',
  'Applied Chemistry',
  'Arabic Language and Its Literature',
  'Architecture',
  'Banking and Finance',
  'Biology Biotechnology',
  'Biomedical Sciences Track',
  'Business Intelligence',
  'Business Management',
  'Cardiac Perfusion',
  'Ceramic Art',
  'Chemical Engineering',
  'Chemistry',
  'Civil Engineering',
  'Communication and Digital Marketing',
  'Communication and Digital Media',
  'Communications Engineering',
  'Computer Engineering',
  'Computer Information Systems',
  'Computer Science',
  'Computer Science in the Job Market',
  'Construction Engineering',
  'Cosmetics and Skin Care',
  'Dental Laboratory Technology',
  'Diploma in Educational Qualification',
  'Doctor of Dental Medicine',
]);









  ////////////////////////////////////////
  RxString postTitle = ''.obs;
  
  RxString postDescription = ''.obs;
  Rx<DateTime?> endDate = DateTime.now().obs;

  void updateEndDate(DateTime newEndDate) {
    endDate.value = newEndDate;
  }

  void updateTitle(String newTitle) {
    postTitle.value = newTitle;
  }

  

  void updateDescription(String newDescription) {
    postDescription.value = newDescription;
  }

  postJob(pageId) async {
    var url = "$urlStarter/user/addNewJob";
    Map<String, dynamic> jsonData = {
      "pageId": pageId,
      "title": postTitle.value,
      "interest": (selectedItems.value).join(','),
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
