import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

getMyPageInfo(pageId)async {
    var url = urlStarter + "/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
  print(responce);
    return responce;
  }
goToMyPageInfo(pageId) async {
 var res = await getMyPageInfo(pageId);
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    print(resbody);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){
      
      //Get.to(ProfileSettings(userData: [resbody["user"]]));
    } 
  }
class PageDetailsController extends GetxController{
}
