

import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/myPage/editPageProfile.dart';
import 'package:http/http.dart' as http;

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





 /*  final List<Map<String, dynamic>> userData = [
    {
      "firstname": "Al Qassam",
      "address":"Aqraba",
      "photo": null,
      "coverImage": null,
      "Description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "contact":"facebook",
      "country":"Palestine",
      "speciality":"progrmming"
    }
  ];*/

   final List<Map<String, dynamic>> userData = [
    {
      "name": "Obaida",
      "Speciality": "Aws",
      "address": "123 Main Street",
      "country": "United States",

      "ContactInfo": "123-456-7890",
      "Description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "photo": null,
      "coverImage": null,
    }
  ];

  goToEditPageProfile(){
    Get.to(EditPageProfile(userData: userData,));
  }


}