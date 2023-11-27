import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SearchControllerImp extends GetxController {
  // Define a dynamic list to store user data
  RxList<Map<String, String>> userList = <Map<String, String>>[].obs;

  // Define a dynamic list to store page data
  RxList<Map<String, String>> pageList = <Map<String, String>>[].obs;


  

searchInDataBase(){

  // here define new global list your result in it 
  // by yourList.assginall(result)
  // the store the global list in the userList or pageList in the onInit() to rebuild the page
}




  @override
  void onInit() {
    // Fetch initial data or perform any setup
    // For now, let's add some dummy data
    for (int i = 0; i < 20; i++) {
      userList.add({
        'name': 'User Name $i',
        'username': '@username$i',
        'imageUrl': 'images/obaida.jpeg',
      });

      pageList.add({
        'name': 'Page Name $i',
        'username': '@pagename$i',
        'imageUrl': 'images/obaida.jpeg',
      });
    }

    super.onInit();
  }
}
