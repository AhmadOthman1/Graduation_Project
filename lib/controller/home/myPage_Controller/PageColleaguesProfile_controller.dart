import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/myPage/seeAboutinfoPageColleagues.dart';

class ColleaguesPageProfile_Controller extends GetxController {

  RxBool isFollowing = false.obs;

  // for profile
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;

  // for cover page
  // for cover image
  final RxString coverImageBytes = ''.obs;
  final RxString coverImageBytesName = ''.obs;
  final RxString coverImageExt = ''.obs;


      final RxMap personalDetails = {
    'name': 'Al Qassam',
    'description': 'Resistance',
    'address': '123 Main Street',
    'contactInfo': 'john.doe@example.com',
    'country': 'Palestine',
    'speciality': 'Liberation of Palestine',
    'pageType': 'public', // or 'private'
  }.obs;


  goToSeeAboutInfoColleagues(){

    Get.to(CollaguesPageSeeAboutInfo(),arguments: {
      'PersonalDetails':personalDetails,
    });

  }



}