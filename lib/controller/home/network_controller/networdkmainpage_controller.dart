
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/Networkspages/ShowGroups.dart';
//import 'package:growify/view/screen/homescreen/Networkspages/ShowGroups.dart';
import 'package:growify/view/screen/homescreen/myPage/ColleaguesPageProfile.dart';
import 'package:growify/view/screen/homescreen/myPage/Pageprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:http/http.dart' as http;

 class PageInfo {
  final String id;
  final String name;
  final String? description;
  final String? country;
  final String? address;
  final String? contactInfo;
  final String? specialty;
  final String? pageType;
  final String? photo;
  final String? coverImage;
  final String? postCount;
  final String? followCount;
  final String? adminType;

  PageInfo(this.id, this.name, this.description, this.country, this.address, this.contactInfo, this.specialty, this.pageType, this.photo, this.coverImage, this.postCount , this.followCount,[this.adminType]);
}


LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class NetworkMainPageControllerImp extends GetxController {
  final RxList<Map<String, dynamic>> colleagues = <Map<String, dynamic>>[].obs;
    late int userPostCount;
  late int userConnectionsCount;

  @override
  void onInit() {
    // Initialize the RxList
   
    super.onInit();
  }


  getDashboard() async {
    var url = "$urlStarter/user/getUserProfileDashboard";
    var responce = await http.post(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),

        });
  print(responce);
    return responce;
  }
loadDashboard() async {
 var res = await getDashboard();
 if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadDashboard();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){
      userPostCount = resbody['userPostCount'];
      userConnectionsCount =resbody['userConnectionsCount'] ;
      print(resbody);
    } 
  }

  @override
  Future getprfilepage() async {
    var url = "$urlStarter/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  @override
  goToprofilepage() async {
    await loadDashboard();
    var res = await getprfilepage();
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToprofilepage();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      GetStorage().write("photo", resbody["user"]["photo"]);
      Get.to(ProfileMainPage(userData: [resbody["user"]], userPostCount: userPostCount, userConnectionsCount: userConnectionsCount));
    }
  }
  @override
  Future getUserProfilePage(String userUsername) async {
    var url =
        "$urlStarter/user/getUserProfileInfo?ProfileUsername=$userUsername";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  @override
  goToUserPage(String userUsername) async {
    if(userUsername == GetStorage().read('username')){
      await goToprofilepage();
      return;
    }
    var res = await getUserProfilePage(userUsername);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToUserPage(userUsername);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      if (resbody['user'] is Map<String, dynamic>) {
        print("ppppp");
        print([resbody["user"]]);

        Get.to(() => ColleaguesProfile(userData: [resbody["user"]]));

        return true;
      }
    }
  }

  /// go to page profileeee
  

 
  @override
  Future getProfilePage(String pageId) async {
    var url =
        "$urlStarter/user/getPageProfileInfo?pageId=$pageId";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  @override
  goToPage(String pageId) async {
    /*if (pageId == GetStorage().read('username')) {
      await goToprofilepage();
      return;
    }*/
    var res = await getProfilePage(pageId);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToPage(pageId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      var page = resbody['Page'];
      if(page['isAdmin']== true){
        Get.to(PageProfile(isAdmin: page['isAdmin'] , userData: PageInfo(page['id'], page['name'], page['description'], page['country'], page['address'], page['contactInfo'], page['specialty'], page['pageType'], page['photo'], page['coverImage'],page['postCount'],page['followCount'],page['adminType'])));
      }else{
        Get.to(ColleaguesPageProfile(following: page['following'],userData: PageInfo(page['id'], page['name'], page['description'], page['country'], page['address'], page['contactInfo'], page['specialty'], page['pageType'], page['photo'], page['coverImage'],page['postCount'],page['followCount'])));
      }
      print(page);
      print(page["isAdmin"]);
    }
  }

  // show groups page
  List<Map<String, dynamic>> pagesData = [
  
];




  goToShowGroups(){

    Get.to( ShowGroupPage(pagesData: pagesData,));
  }

  // get from database  . . . . . . . . . . . . . ..  .  .


  getMyPageGroups() async {
    var url = "$urlStarter/user/getUserGroups";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

goToShowGroupPage() async {
  var res = await getMyPageGroups();
  
  if (res == null) {
    // Handle the case where the response is null
    // You might want to show an error message or take appropriate action
    return;
  }

  if (res.statusCode == 403) {
    await getRefreshToken(GetStorage().read('refreshToken'));
    goToShowGroupPage();
    return;
  } else if (res.statusCode == 401) {
    _logoutController.goTosigninpage();
  }

  var resbody = jsonDecode(res.body);

  if (res.statusCode == 409) {
    return resbody['message'];
  } else if (res.statusCode == 200) {
    pagesData.clear();

    if (resbody['groups'] != null) {
      pagesData = (resbody['groups'] as List<dynamic>).map((dynamic group) {
        print(group);
        print("******");
        return {
          'pageId': group['pageId'],
          'name': group['name'],
          'id': group['groupId'],
          'description': group['description'],
          'parentNode': group['parentGroup'],
          'membersendmessage': group['memberSendMessage'],
        };
      }).toList();
    }

    print("AAAAAAAAAAAAAAAAAAAAAAAALLLLLLLLLLLLLLLL");
    print(pagesData);
    Get.to(ShowGroupPage(pagesData: pagesData));
  }
}

 


}