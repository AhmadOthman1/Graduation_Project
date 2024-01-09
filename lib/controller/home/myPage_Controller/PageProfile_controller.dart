

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
    'description': "im Main Group",
    'parentNode': null,
    'membersendmessage': false
  },
  {
    'name': "Group 1", 
    'id':8,
    'description': "im Group 1",
    'parentNode': "Main Group", 
    'membersendmessage': true
  },
  {
    'name': "Sub 1.1", 
    'id':7,
    'description': "im Sub 1.1",
    'parentNode': "Group 1", 
    'membersendmessage': false
  },
  {
    'name': "Sub 1.2", 
    'id':5,
    'description': "im Sub 1.2",
    'parentNode': "Group 1", 
    'membersendmessage': false
  },
];



  goToShowGroupPage(String pageId){

print("why whyw jjjjjjjjjjjjjjjjjjjjjjjjjj");
print(pageId);
print("why whyw jjjjjjjjjjjjjjjjjjjjjjjjjj");

    Get.to(GroupPage(pageId: pageId, groupsData: groupsData));
  }

    


  


}