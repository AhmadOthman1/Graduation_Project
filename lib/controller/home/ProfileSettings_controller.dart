import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';

abstract class ProfileSettingsController extends GetxController {
  goToSettingsPgae();
  SaveChanges();
}

class ProfileSettingsControllerImp extends ProfileSettingsController {
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
  RxString textFieldText4= ''.obs;
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
  
  @override
  SaveChanges() {
    print(textFieldText);
  
  }

}