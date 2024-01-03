import 'package:get/get.dart';

class NewJobControllerImp extends GetxController {
  RxString postTitle = ''.obs;
  RxString postInterest = ''.obs;
  RxString postDescription = ''.obs;
  Rx<DateTime?> endDate = DateTime.now().obs;

  void updateEndDate(DateTime newEndDate) {
    endDate.value = newEndDate;
  }

  void updateTitle(String newTitle) {
    postTitle.value = newTitle;
  }

  void updateInterest(String newInterest) {
    postInterest.value = newInterest;
  }

  void updateDescription(String newDescription) {
    postDescription.value = newDescription;
  }

  Future<String?> postJob() async {
    // Implement your post job logic here
    return null; // Return an error message if there's an issue
  }
}
