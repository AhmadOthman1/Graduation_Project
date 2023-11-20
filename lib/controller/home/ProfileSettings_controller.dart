import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';

abstract class ProfileSettingsController extends GetxController {
  goToSettingsPgae();
}

class ProfileSettingsControllerImp extends ProfileSettingsController {
  goToSettingsPgae() {
    Get.toNamed(AppRoute.settings);
  }
// first textfiled
  RxBool isTextFieldEnabled = false.obs;
  RxString textFieldText = ''.obs;
  RxBool isTextFieldPublic = false.obs;
// second textfiled
  RxBool isTextFieldEnabled2 = false.obs;
  RxString textFieldText2 = ''.obs;
  RxBool isTextFieldPublic2 = false.obs;
  // third textfiled
  RxBool isTextFieldEnabled3 = false.obs;
  RxString textFieldText3 = ''.obs;
  RxBool isTextFieldPublic3 = false.obs;
  // four textfiled
  RxBool isTextFieldEnabled4 = false.obs;
  RxString textFieldText4= ''.obs;
  RxBool isTextFieldPublic4= false.obs;
  // five textfiled
  RxBool isTextFieldEnabled5 = false.obs;
  RxString textFieldText5 = ''.obs;
  RxBool isTextFieldPublic5 = false.obs;
  // six textfiled
  RxBool isTextFieldEnabled6 = false.obs;
  RxString textFieldText6 = ''.obs;
  RxBool isTextFieldPublic6= false.obs;
  // seven textfiled
  RxBool isTextFieldEnabled7 = false.obs;
  RxString textFieldText7 = ''.obs;
  RxBool isTextFieldPublic7 = false.obs;

}