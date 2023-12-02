import 'package:get/get.dart';

class ChatMainPageController extends GetxController {

   late RxList<Map<String, dynamic>> localColleagues= <Map<String, dynamic>>[].obs;
   late RxList<Map<String, dynamic>> colleaguesPreviousmessages= <Map<String, dynamic>>[].obs;

     int Upage = 1;
   int pageSize = 10;

   getColleaguesfromDataBase(){

   }

     RxList<String> moreOptions = <String>[
    'delete conversation',
    
  ].obs;

    void onMoreOptionSelected(String option) {
    // Handle the selected option here
    switch (option) {
      case 'delete conversation':
        // Implement save post functionality
        break;

    }
  }



}