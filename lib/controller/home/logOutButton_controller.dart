import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';

abstract class LogOutButtonController extends GetxController {
goTosigninpage();


}

class LogOutButtonControllerImp extends GetxController {
goTosigninpage(){
  Get.toNamed(AppRoute.login);
}
}
