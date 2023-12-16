
import 'package:get/get.dart';

class ShowColleaguesControllerImp extends GetxController {

  // for profile
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;



  late RxList<Map<String, dynamic>> localColleagues= <Map<String, dynamic>>[].obs;


  int Upage = 1;
   int pageSize = 10;
   getColleaguesfromDataBase(){
      
   }

   




}