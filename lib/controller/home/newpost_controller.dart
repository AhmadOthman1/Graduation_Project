import 'package:get/get.dart';


class NewPostControllerImp extends GetxController {
  RxString postContent = ''.obs;
  RxString selectedPrivacy = 'Any One'.obs;

  void post() {
    print('Posting: ${postContent.value}, Privacy: ${selectedPrivacy.value}');
  }

  void updatePrivacy(String newValue) {
    selectedPrivacy.value = newValue;
    update();
  }

  final RxString postImageBytes = ''.obs;
  final RxString postImageBytesName = ''.obs;
  final RxString postImageExt = ''.obs;

  void updateProfileImage(
    String base64String,
    String imageName,
    String imageExt,
  ) {
    postImageBytes.value = base64String;
    postImageBytesName.value = imageName;
    postImageExt.value = imageExt;
    update(); // This triggers a rebuild of the widget tree
  }
}
