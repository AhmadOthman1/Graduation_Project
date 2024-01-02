

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

    final RxMap personalDetails = {
    'name': 'John Doe',
    'description': 'A Flutter developer',
    'address': '123 Main Street',
    'contactInfo': 'john.doe@example.com',
    'country': 'United States',
    'speciality': 'Mobile App Development',
    'pageType': 'public', // or 'private'
  }.obs;


  goToSeeAboutInfo(){

    Get.to(MyPageSeeAboutInfo(),arguments: {
      'PersonalDetails':personalDetails,
    });

  }


}