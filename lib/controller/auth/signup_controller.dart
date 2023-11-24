import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/view/screen/auth/SignIn&SignUp/signup.dart';
import 'package:http/http.dart' as http;
import 'package:growify/global.dart';
abstract class SignUpController extends GetxController{
signup(firstName,lastName,userName,email,password,phone,dateOfBirth);
goToSignIn();
postSignup(firstName,lastName,userName,email,password,phone,dateOfBirth);
}





//////////////

class SignUpControllerImp extends SignUpController{

  RxBool isTextFieldEnabled5 = true.obs;
  // for date picker 
final TextEditingController startDateController = TextEditingController();
  final RxBool isSaveVisible = false.obs;
  RxString textFieldText5 = ''.obs;
 Future<void> pickStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
   

    if (pickedDate != null && pickedDate != DateTime.now()) {
      startDateController.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      isTextFieldEnabled5.value = true; // Show the "Save" button
    }
  }
  //
    void clearTextField() {
    startDateController.text = '';
    // You can also clear other related fields if needed
    textFieldText5.value = ''; // Assuming you have this variable in your controller
  }



  late TextEditingController username;
  late TextEditingController phone;
  late TextEditingController email;
  late TextEditingController password;
   late TextEditingController dateOfBirth;

  bool isshowpass=true;
  var responceBody;
  showPassord(){
    isshowpass=isshowpass==true?false:true;
    update();
  }
   Future postSignup(firstName,lastName,userName,email,password,phone,dateOfBirth) async {
    var url = urlStarter + "/user/signup";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "userName": userName.trim(),
          "email": email.trim(),
          "password": password.trim(),
          "phone": phone.trim(),
          "dateOfBirth": dateOfBirth.trim(),
          "firstName": firstName.trim(),
          "lastName": lastName.trim(),
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    responceBody = jsonDecode(responce.body);
    return responce;
  }


  @override
  signup(firstName,lastName,userName,email,password,phone,dateOfBirth) async {
    var res = await postSignup(firstName,lastName,userName,email,password,phone,dateOfBirth);
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){
      Get.offNamed(AppRoute.verifycodeaftersignup);
      clearTextField();
    }
    
    //Get.offNamed(AppRoute.verifycodeaftersignup);
  }
  
  
  @override
  goToSignIn() {
 Get.offNamed(AppRoute.login);
  }

  @override
  void onInit() {
    username=TextEditingController();
    phone=TextEditingController();
    email=TextEditingController();
    password=TextEditingController();
    dateOfBirth=TextEditingController();
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    username.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
    dateOfBirth.dispose();
    // TODO: implement dispose
    super.dispose();
  }

}