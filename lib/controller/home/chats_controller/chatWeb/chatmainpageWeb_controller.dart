import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class ChatMainWebPageController extends GetxController {

   late RxList<Map<String, dynamic>> localColleagues= <Map<String, dynamic>>[].obs;
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

  // just get the chat main page when i run in web not mobile 

   final RxList<Map<String, dynamic>> MycolleaguesWeb =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> colleaguesPreviousmessagesWed =
      <Map<String, dynamic>>[].obs;
  @override
  void onInit() {
    // Initialize the RxList

    super.onInit();
    goToChat();
  }
    getChats() async {
    var url = "$urlStarter/user/getChats";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  goToChat() async {
    var res = await getChats();
    print(res.statusCode);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToChat();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      print("ok then the data recive for me");
      print(resbody['activeConnectionsInfo']);
      MycolleaguesWeb.clear();
      
      for (var conversation in resbody['activeConnectionsInfo']) {
        var name = conversation["firstname"] + " " + conversation["lastname"];
        var username = conversation["username"];
        var photo = conversation["photo"];
        final Map<String, dynamic> extractedInfo = {
          'name': name,
          'username': username,
          'photo': photo,
          'type': "U",
        };
        MycolleaguesWeb.add(extractedInfo);
  
      }
      /*Mycolleagues.assignAll(
          List<Map<String, dynamic>>.from(resbody['activeConnectionsInfo']));*/
      colleaguesPreviousmessagesWed.clear();
      for (var conversation
          in List<Map<String, dynamic>>.from(resbody['uniqueConversations'])) {
        var name;
        var username;
        var photo;
        String type = "U";
        if (conversation['senderUsername_FK'] != null &&
            conversation['senderUsername_FK']['username'] !=
                GetStorage().read('username')) {
          name = conversation['senderUsername_FK']['firstName'] +
              " " +
              conversation['senderUsername_FK']['lastName'];
          username = conversation['senderUsername_FK']['username'];
          photo = conversation['senderUsername_FK']['photo'];
          type = "U";
        } else if (conversation['receiverUsername_FK'] != null &&
            conversation['receiverUsername_FK']['username'] !=
                GetStorage().read('username')) {
          name = conversation['receiverUsername_FK']['firstName'] +
              " " +
              conversation['receiverUsername_FK']['lastName'];
          username = conversation['receiverUsername_FK']['username'];
          photo = conversation['receiverUsername_FK']['photo'];
          type = "U";
        } else if (conversation['senderPageId_FK'] != null) {
          name = conversation['senderPageId_FK']['name'];
          username = conversation['senderPageId_FK']['id'];
          photo = conversation['senderPageId_FK']['photo'];
          type = "P";
        } else if (conversation['receiverPageId_FK'] != null) {
          name = conversation['receiverPageId_FK']['name'];
          username = conversation['receiverPageId_FK']['id'];
          photo = conversation['receiverPageId_FK']['photo'];
          type = "P";
        }
        final Map<String, dynamic> extractedInfo = {
          'name': name,
          'username': username,
          'photo': photo,
          'type': type,
        };
                print(name);

        colleaguesPreviousmessagesWed.add(extractedInfo);
      }
          MycolleaguesWeb.refresh();
    colleaguesPreviousmessagesWed.refresh();
      //print(colleaguesPreviousmessages);
    }
  }



}