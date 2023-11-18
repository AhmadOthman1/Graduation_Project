import 'package:get/get.dart';







   bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }
   bool isDate(String s) =>
    hasMatch(s, r'^\d{4}-\d{2}-\d{2}$');

validInput(String value ,int max ,int min ,String type){

//// type
  if(type=="username"){
    if(!GetUtils.isUsername(value)){return "Not Valid Name"; }
  }

if(type=="dateOfBirth"){
    if(!isDate(value)){return "Not Valid Date Of Birth"; }
  }
    if(type=="email"){
    if(!GetUtils.isEmail(value)){return "Not Valid Email"; }
  }


    if(type=="phone"){
    if(!GetUtils.isPhoneNumber(value)){return "Not Valid Phone  "; }
  }

//// length
  if(value.isEmpty){
    return "Can't be empty";
  }

  if(value.length < min){
    return "Can't be less than $min";
  }

  if(value.length > max){
    return "Can't be larger than $max";
  }



}