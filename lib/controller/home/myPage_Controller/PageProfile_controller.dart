

import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/myPage/editPageProfile.dart';
import 'package:growify/view/screen/homescreen/myPage/seeAboutInfoMyPage.dart';

class PageProfileController extends GetxController {

  // for profile
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;

  // for cover page
  // for cover image
  final RxString coverImageBytes = ''.obs;
  final RxString coverImageBytesName = ''.obs;
  final RxString coverImageExt = ''.obs;



  goToEditPageProfile(userData){
    Get.to(EditPageProfile(userData: userData,));
  }

    


  


}