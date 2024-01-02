import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class NewPostControllerImp extends GetxController {
  RxString postContent = ''.obs;
  RxString selectedPrivacy = 'Any One'.obs;

  postNewPost(postImageBytes, postImageBytesName, postImageExt,
      [bool? isPage, String? pageId]) async {
    if (isPage != null && isPage) {
      var url = "$urlStarter/user/postNewPagePost";

      Map<String, dynamic> jsonData = {
        "postContent": postContent.value,
        "postImageBytes": postImageBytes,
        "postImageBytesName": postImageBytesName,
        "postImageExt": postImageExt,
        "pageId":pageId,
      };
      String jsonString = jsonEncode(jsonData);
      int contentLength = utf8.encode(jsonString).length;
      var responce =
          await http.post(Uri.parse(url), body: jsonString, headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      });
      return responce;
    } else {
      var url = "$urlStarter/user/postNewUserPost";

      Map<String, dynamic> jsonData = {
        "postContent": postContent.value,
        "selectedPrivacy": selectedPrivacy.value,
        "postImageBytes": postImageBytes,
        "postImageBytesName": postImageBytesName,
        "postImageExt": postImageExt,
      };
      String jsonString = jsonEncode(jsonData);
      int contentLength = utf8.encode(jsonString).length;
      var responce =
          await http.post(Uri.parse(url), body: jsonString, headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      });
      return responce;
    }
  }

  post(postImageBytes, postImageBytesName, postImageExt,
      [bool? isPage, String? pageId]) async {
    var res = await postNewPost(
        postImageBytes, postImageBytesName, postImageExt, isPage, pageId);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      post(postImageBytes, postImageBytesName, postImageExt, isPage, pageId);
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
        Get.offNamed(AppRoute.homescreen);
    }
    //print('Posting: ${postContent.value}, Privacy: ${selectedPrivacy.value}');
  }

  void updatePrivacy(String newValue) {
    selectedPrivacy.value = newValue;
    update();
  }

  final RxString postImageBytes = ''.obs;
  final RxString postImageBytesName = ''.obs;
  final RxString postImageExt = ''.obs;

  void updateProfileImage(
    String base64String,
    String imageName,
    String imageExt,
  ) {
    postImageBytes.value = base64String;
    postImageBytesName.value = imageName;
    postImageExt.value = imageExt;
    update(); // This triggers a rebuild of the widget tree
  }
}
