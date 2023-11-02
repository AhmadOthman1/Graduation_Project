import 'package:get/get.dart';

validInput(String value ,int max ,int min ,String type){

//// type
  if(type=="username"){
    if(!GetUtils.isUsername(value)){return "Not Valid UserName"; }
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