import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/view/screen/homescreen/settings/Profilesettings.dart';

abstract class SettingsController extends GetxController {

    // put data from database here
  static const String Firstname = 'Obaida';
  static const String Lastname = 'Aws';
  static const String Address = 'Aqraba';
  static const String Country = 'Palestine';
  static const String DateOfBirth = '2001-05-25';
  static const String Phone = '0594376261';
  static const String Bio = 'I will be the best wherever I am';

  final List<Map<String, dynamic>> userData = const [
    {
      "name": Firstname,
      "lastname": Lastname,
      "address": Address,
      "country": Country,
      "dateOfBirth": DateOfBirth,
      "phone": Phone,
      "bio": Bio,
    },
  ];

goToProfileSettingsPgae();


}

class SettingsControllerImp extends SettingsController {


goToProfileSettingsPgae(){
 // Get.toNamed(AppRoute.profilesetting);
 Get.to(ProfileSettings(userData: userData));
 

}
}
