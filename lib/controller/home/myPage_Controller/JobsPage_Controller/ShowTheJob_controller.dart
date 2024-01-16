import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/ColleaguesPageProfile.dart';
import 'package:growify/view/screen/homescreen/myPage/Pageprofile.dart';
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
  final String? adminType;

  PageInfo(this.id, this.name, this.description, this.country, this.address, this.contactInfo, this.specialty, this.pageType, this.photo, this.coverImage, this.postCount , this.followCount,this.adminType);
}

class ShowTheJobImp extends GetxController {

postSaveApplication(cvBytes,cvName,cvExt,notice,jobId)async {
    var url = "$urlStarter/user/saveJobApplication";
    print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
    Map<String, dynamic> jsonData = {
      "jobId":jobId,
      "cvBytes": cvBytes,
      "cvName": cvName,
      "cvExt": cvExt,
      "notice": notice,
    };
    String jsonString = jsonEncode(jsonData);
    int contentLength = utf8.encode(jsonString).length;
    var responce = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  SaveApplication(cvBytes,cvName,cvExt,notice,jobId) async {
var res = await postSaveApplication(cvBytes,cvName,cvExt,notice,jobId);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      SaveApplication(cvBytes,cvName,cvExt,notice,jobId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    if (res.statusCode == 409 || res.statusCode == 500) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      return resbody['message'];
    }
  }

  // go to the page 
    Future getProfilePage(String pageId) async {
    var url =
        "$urlStarter/user/getPageProfileInfo?pageId=$pageId";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

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
        Get.to(ColleaguesPageProfile(following: page['following'],userData: PageInfo(page['id'], page['name'], page['description'], page['country'], page['address'], page['contactInfo'], page['specialty'], page['pageType'], page['photo'], page['coverImage'],page['postCount'],page['followCount'],page['adminType'])));
      }
      print(page);
      print(page["isAdmin"]);
    }
  }

  
  


}
