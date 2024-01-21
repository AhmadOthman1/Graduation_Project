import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class PageChatMainPageController extends GetxController {

   late RxList<Map<String, dynamic>> colleaguesPreviousmessages= <Map<String, dynamic>>[].obs;

     int Upage = 1;
   int pageSize = 10;

   getColleaguesfromDataBase(){

   }

     RxList<String> moreOptions = <String>[
    'delete conversation',
    
  ].obs;

    void onMoreOptionSelected(String option) {
    // Handle the selected option here
    switch (option) {
      case 'delete conversation':
        // Implement save post functionality
        break;

    }
  }
generatePageAccessToken(pageId) async {
  var url = "$urlStarter/user/generatePageAccessToken?pageId=${pageId}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    if (responce.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      generatePageAccessToken(pageId);
      return;
    } else if (responce.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    
    if (responce.statusCode == 409) {
      var resbody = jsonDecode(responce.body);
      return resbody['message'];
    } else if (responce.statusCode == 200) {
      var resbody = jsonDecode(responce.body);
      return resbody['accessToken'];
      
    }
}


}