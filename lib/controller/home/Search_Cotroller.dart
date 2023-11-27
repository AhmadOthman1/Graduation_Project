import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:http/http.dart' as http;

class SearchControllerImp extends GetxController {
  // Define a dynamic list to store user data
  RxList<Map<String, String>> userList = <Map<String, String>>[
    {
        'name': 'islam',
        'username': '@username',
        'imageUrl': 'images/obaida.jpeg',
        'email':'awsobaida07@gmail.com'
      },
      {
        'name': 'islam',
        'username': '@username',
        'imageUrl': 'images/obaida.jpeg',
        'email':'s11923787@stu.najah.edu'
      },


  ].obs;

  // Define a dynamic list to store page data
  RxList<Map<String, String>> pageList = <Map<String, String>>[].obs;


    // for user and page chek null
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;

  RxBool checkTheSearch = false.obs;

 

searchInDataBase(){

  // here define new global list your result in it 
  // by yourList.assginall(result)
  // the store the global list in the userList or pageList in the onInit() to rebuild the page
}

// when i press on the result users
//////////////////////////////////////////////////////////
  @override

   Future getprfileColleaguespage(String email) async{
        var url = urlStarter + "/user/settingsGetMainInfo?email=${email}";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
  print(responce);
    return responce;

  }

  

  

    @override
  goToProfileColleaguesPage(String email)async {
         var res = await getprfileColleaguespage(email);
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    print(resbody);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){


    Get.to(ColleaguesProfile(userData: [resbody["user"]]));
  }
  
 
}



////////////////////////////////////////////////////////
  @override
  void onInit() {
    // Fetch initial data or perform any setup
    // For now, let's add some dummy data
    for (int i = 0; i < 20; i++) {
    /*  userList.add({
        'name': 'User Name $i',
        'username': '@username$i',
        'imageUrl': 'images/obaida.jpeg',
      });*/

      pageList.add({
        'name': 'Page Name $i',
        'username': '@pagename$i',
        'imageUrl': 'images/obaida.jpeg',
      });
    }

    super.onInit();
  }
}
