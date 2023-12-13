import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

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
        "$urlStarter/user/getSearchData?email=${GetStorage().read("loginemail")}&type=${searchType}&search=${searchValue}&page=${page}&pageSize=${pageSize}";
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
          (users as List<dynamic>?)
                  ?.map<Map<String, String>>(
                    (user) => (user as Map<String, dynamic>)
                        .map<String, String>(
                            (key, value) => MapEntry(key, value.toString())),
                  )
                  .toList() ??
              [],
        );
        return resbody["users"];
      } else if (searchType == "p") {}
    }
  }

  // when i press on the result users
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
        print([resbody["user"]]);
        Get.to(ColleaguesProfile(userData: [resbody["user"]]));
        return true;
      }
    }
  }

  @override
  void onInit() {
    // Fetch initial data or perform any setup
    // For now, let's add some dummy data

    super.onInit();
  }
}
