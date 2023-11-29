import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
abstract class LogOutButtonController extends GetxController {
goTosigninpage();


}

class LogOutButtonControllerImp extends GetxController {
goTosigninpage(){
 // GetStorage().write("loginemail", "");
 // GetStorage().write("loginpassword", "");
  GetStorage().remove('loginemail');
  GetStorage().remove('loginpassword');
  GetStorage().remove('refreshToken');
  GetStorage().remove('accessToken');
  print(GetStorage().read('loginemail'));
  print(GetStorage().read("loginemail"));
    firstName="";
  lastName="";
  userName="";
  email="";
  password="";
  phone="";
   dateOfBirth="";
   code="";

  Get.toNamed(AppRoute.login);
}
}
