import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/ColleaguesPageProfile.dart';
import 'package:growify/view/screen/homescreen/myPage/Pageprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());


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

  PageInfo(this.id, this.name, this.description, this.country, this.address, this.contactInfo, this.specialty, this.pageType, this.photo, this.coverImage, this.postCount , this.followCount);
}


class SearchControllerImp extends GetxController {
  // Define a dynamic list to store user data
  RxList<Map<String, String>> userList = <Map<String, String>>[].obs;
  String? searchValue;
  int Upage = 1;
  int Ppage = 1;
  int pageSize = 10;
  // Define a dynamic list to store page data
  RxList<Map<String, String>> pageList = <Map<String, String>>[].obs;
  // for user and page chek null
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;

  RxBool checkTheSearch = false.obs;
  late int userPostCount;
  late int userConnectionsCount;





  searchInDataBase(searchValue, page, pageSize, searchType) async {
    var url =
        "$urlStarter/user/getSearchData?email=${GetStorage().read("loginemail")}&type=$searchType&search=$searchValue&page=$page&pageSize=$pageSize";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  goTosearchPage(searchValue, page, searchType) async {
    var res = await searchInDataBase(searchValue, page, pageSize, searchType);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goTosearchPage(searchValue, page, searchType);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      if (searchType == "U") {
        final List<dynamic>? users = resbody["users"];
        userList.addAll(
          (users)
                  ?.map<Map<String, String>>(
                    (user) => (user as Map<String, dynamic>)
                        .map<String, String>(
                            (key, value) => MapEntry(key, value.toString())),
                  )
                  .toList() ??
              [],
        );
        return resbody["users"];
      } else if (searchType == "P") {
        print(";;;;;;;;;;;;;;;;;");
        final List<dynamic>? pages = resbody["pages"];
        pageList.addAll(
          (pages)
                  ?.map<Map<String, String>>(
                    (page) => (page as Map<String, dynamic>)
                        .map<String, String>(
                            (key, value) => MapEntry(key, value.toString())),
                  )
                  .toList() ??
              [],
        );
        print(resbody["pages"]);
        return resbody["users"];
      }
    }
  }

  // when i press on the result users
  getDashboard() async {
    var url = "$urlStarter/user/getUserProfileDashboard";
    var responce = await http.post(Uri.parse(url), headers: {
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
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      userPostCount = resbody['userPostCount'];
      userConnectionsCount = resbody['userConnectionsCount'];
      print(resbody);
    }
  }

  @override
  Future getprfilepage() async {
    var url =
        "$urlStarter/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
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
      Get.to(ProfileMainPage(
          userData: [resbody["user"]],
          userPostCount: userPostCount,
          userConnectionsCount: userConnectionsCount));
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
    if (userUsername == GetStorage().read('username')) {
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
        //  Get.to(ColleaguesProfile(userData: [resbody["user"]]));

        Get.to(() => ColleaguesProfile(userData: [resbody["user"]]));

        return true;
      }
    }
  }
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
        Get.to(PageProfile(isAdmin: page['isAdmin'] , userData: PageInfo(page['id'], page['name'], page['description'], page['country'], page['address'], page['contactInfo'], page['specialty'], page['pageType'], page['photo'], page['coverImage'],page['postCount'],page['followCount'])));
      }else{
        Get.to(ColleaguesPageProfile(following: page['following'],userData: PageInfo(page['id'], page['name'], page['description'], page['country'], page['address'], page['contactInfo'], page['specialty'], page['pageType'], page['photo'], page['coverImage'],page['postCount'],page['followCount'])));
      }
      print(page);
      print(page["isAdmin"]);
    }
  }
  @override
  void onInit() {
    // Fetch initial data or perform any setup
    // For now, let's add some dummy data

    super.onInit();
  }
}
