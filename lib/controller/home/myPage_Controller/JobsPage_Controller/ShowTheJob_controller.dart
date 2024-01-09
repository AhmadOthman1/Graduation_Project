import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;




LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

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
      return res.statusCode.toString() + ":" + resbody['message'];
    } else if (res.statusCode == 200) {
      
    }
  }
  


}
