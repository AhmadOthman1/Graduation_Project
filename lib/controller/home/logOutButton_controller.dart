import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';

abstract class LogOutButtonController extends GetxController {
goTosigninpage();


}

class LogOutButtonControllerImp extends GetxController {
goTosigninpage(){
 // GetStorage().write("loginemail", "");
 // GetStorage().write("loginpassword", "");
  GetStorage().remove('loginemail');
  GetStorage().remove('loginpassword');

  Get.toNamed(AppRoute.login);
}
}
