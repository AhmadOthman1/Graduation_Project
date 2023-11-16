import 'package:get/get.dart';

abstract class NewPostController extends GetxController {
  RxString postContent = ''.obs;
  RxString selectedPrivacy = 'Any One'.obs; // Add this line

  void post();
  void uploadImage();
  void uploadVideo();
  void updatePrivacy(String newValue);
}

class NewPostControllerImp extends GetxController {
  RxString postContent = ''.obs;
  RxString selectedPrivacy = 'Any One'.obs;

  void post() {
    print('Posting: ${postContent.value}, Privacy: ${selectedPrivacy.value}');
  }

  void uploadImage() {
    // Handle image upload logic
  }

  void uploadVideo() {
    // Handle video upload logic
  }

  void updatePrivacy(String newValue) {
    selectedPrivacy.value = newValue;
    update();
  }
}
