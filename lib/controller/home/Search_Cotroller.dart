import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:http/http.dart' as http;
LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class SearchControllerImp extends GetxController {
  // Define a dynamic list to store user data
  RxList<Map<String, String>> userList = <Map<String, String>>[


  ].obs;

  // Define a dynamic list to store page data
  RxList<Map<String, String>> pageList = <Map<String, String>>[].obs;


    // for user and page chek null
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;

  RxBool checkTheSearch = false.obs;

 

searchInDataBase()async {
    var url = "$urlStarter/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),
        });
  print(responce);
    return responce;
  }
goTosearchPgae() async {
 var res = await searchInDataBase();
 if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goTosearchPgae();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){
      userList=resbody["user"];
    } 
 

  }
// when i press on the result users
//////////////////////////////////////////////////////////
  @override

   Future getprfileColleaguespage(String email) async{
        var url = "$urlStarter/user/settingsGetMainInfo?email=$email";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),
        });
  print(responce);
    return responce;

  }

  

  

    @override
  goToProfileColleaguesPage(String email)async {
         var res = await getprfileColleaguespage(email);
         if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToProfileColleaguesPage(email);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){


    Get.to(ColleaguesProfile(userData: [resbody["user"]]));
  }
  
 
}



////////////////////////////////////////////////////////
  @override
  void onInit() {
    // Fetch initial data or perform any setup
    // For now, let's add some dummy data
    for (int i = 0; i < 20; i++) {
    /*  userList.add({
        'name': 'User Name $i',
        'username': '@username$i',
        'imageUrl': 'images/obaida.jpeg',
      });*/

      pageList.add({
        'name': 'Page Name $i',
        'username': '@pagename$i',
        'imageUrl': 'images/obaida.jpeg',
      });
    }

    super.onInit();
  }
}
