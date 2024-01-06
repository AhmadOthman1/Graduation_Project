

import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/Groups/ShowAllGroup.dart';
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

 late List<Map<String, dynamic>> groupsData = [
  {
    'name': "Main Group", 
    'id':3,
    'description': null,
    'parentNode': null,
    'usersendmessage': false
  },
  {
    'name': "Group 1", 
    'id':8,
    'description': null,
    'parentNode': "Main Group", 
    'usersendmessage': false
  },
  {
    'name': "Sub 1.1", 
    'id':7,
    'description': null,
    'parentNode': "Parent Group 1", 
    'usersendmessage': false
  },
  {
    'name': "Sub 1.2", 
    'id':5,
    'description': null,
    'parentNode': "Parent Group 1", 
    'usersendmessage': false
  },
];



  goToShowGroupPage(String pageId){



    Get.to(GroupPage(pageId: pageId, groupsData: groupsData));
  }

    


  


}