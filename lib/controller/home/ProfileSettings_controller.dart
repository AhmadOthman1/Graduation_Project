import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

abstract class ProfileSettingsController extends GetxController {
  goToSettingsPgae();
  SaveChanges(
      profileImageBytes,
      profileImageBytesName,
      profileImageExt,
      coverImageBytes,
      coverImageBytesName,
      coverImageExt,
      cvBytes,
      cvName,
      cvExt);
  postSaveChanges(
      profileImageBytes,
      profileImageBytesName,
      profileImageExt,
      coverImageBytes,
      coverImageBytesName,
      coverImageExt,
      cvBytes,
      cvName,
      cvExt);
}
String? Email=GetStorage().read("loginemail") ;
/**
 List<int>? profileImageBytes;
  String? profileImageBytesName;
  String? profileImageExt;
  List<int>? coverImageBytes;
  String? coverImageBytesName;
  String? coverImageExt;
  List<int>? cvBytes ;
  String? cvName ;
  String? cvExt ;
 */

class ProfileSettingsControllerImp extends ProfileSettingsController {
  @override
  goToSettingsPgae() {
    Get.toNamed(AppRoute.settings);
  }

// first textfiled
  RxBool isTextFieldEnabled = false.obs;
  RxString textFieldText = ''.obs;
// second textfiled
  RxBool isTextFieldEnabled2 = false.obs;
  RxString textFieldText2 = ''.obs;
  // third textfiled
  RxBool isTextFieldEnabled3 = false.obs;
  RxString textFieldText3 = ''.obs;
  // four textfiled
  RxBool isTextFieldEnabled4 = false.obs;
  RxString textFieldText4 = ''.obs;
  // five textfiled
  RxBool isTextFieldEnabled5 = false.obs;
  RxString textFieldText5 = ''.obs;
  // six textfiled
  RxBool isTextFieldEnabled6 = false.obs;
  RxString textFieldText6 = ''.obs;
  // seven textfiled
  RxBool isTextFieldEnabled7 = false.obs;
  RxString textFieldText7 = ''.obs;

  // you can take the data from the above variable textFieldText,textFieldText1 ......

  

  postSaveChanges(profileImageBytes,profileImageBytesName,profileImageExt,coverImageBytes,coverImageBytesName,coverImageExt,cvBytes,cvName,cvExt) async {
    var url = urlStarter + "/user/settingsChangeMainInfo";
 
    
    Map<String, dynamic> jsonData = {
      "email":Email, 
      "firstName":
          (isTextFieldEnabled == true) ? textFieldText!.trim() : null,
      "lastName":
          (isTextFieldEnabled2 == true) ? textFieldText2!.trim() : null,
      "address":
          (isTextFieldEnabled3 == true) ? textFieldText3!.trim() : null,
      "country":
          (isTextFieldEnabled4 == true) ? textFieldText4!.trim() : null,
      "dateOfBirth":
          (isTextFieldEnabled5 == true) ? textFieldText5!.trim() : null,
      "phone":
          (isTextFieldEnabled6 == true) ? textFieldText6!.trim() : null,
      "bio": (isTextFieldEnabled7 == true) ? textFieldText7!.trim() : null,
      "profileImageBytes":profileImageBytes,
      "profileImageBytesName":profileImageBytesName,
      "profileImageExt":profileImageExt,
      "coverImageBytes":coverImageBytes,
      "coverImageBytesName":coverImageBytesName,
      "coverImageExt":coverImageExt,
      "cvBytes":cvBytes,
      "cvName":cvName,
      "cvExt":cvExt,
  // other fields...
  };
    String jsonString = jsonEncode(jsonData);
    int contentLength = utf8.encode(jsonString).length;
    var responce = await http.post(Uri.parse(url),
        body: jsonString,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    return responce;
  }
  SaveChanges(
      profileImageBytes,
      profileImageBytesName,
      profileImageExt,
      coverImageBytes,
      coverImageBytesName,
      coverImageExt,
      cvBytes,
      cvName,
      cvExt) async {
    var res = await postSaveChanges(
        profileImageBytes,
        profileImageBytesName,
        profileImageExt,
        coverImageBytes,
        coverImageBytesName,
        coverImageExt,
        cvBytes,
        cvName,
        cvExt);
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    if (res.statusCode == 409 || res.statusCode == 500 ) {
      return res.statusCode+":"+resbody['message'];
    } else if (res.statusCode == 200) {
      Get.offNamed(AppRoute.homescreen);
    }
  }
}
