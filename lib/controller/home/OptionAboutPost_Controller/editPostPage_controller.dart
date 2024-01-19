import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class EditPostPageControllerImp extends GetxController {
  RxString postContent = ''.obs;
  RxString selectedPrivacy = 'Any One'.obs;

  postNewPost(int postId) async {
   
      var url = "$urlStarter/user/postUpdatePagePost";

      Map<String, dynamic> jsonData = {
        "postId":postId,
        "newText": postContent.value,
      
   
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

  post(int postId ) async {
    var res = await postNewPost(postId);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      post(postId);
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
