import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:growify/controller/home/myPages_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/profilepages/seeAboutinfo.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;



class ProfileMainPageControllerImp extends GetxController {

  // get data from database 
    final RxList<Map<String, String>> PersonalDetails =
      <Map<String, String>>[

    {
      'firstName': 'Asem',
      'lastName': 'Aws',
      'Country': 'Palestine',
      'Address':'Aqraba',
      'userName': '@obaida',
      'Phone': '0594376261',
      'DateofBirth':'2001-05-25',
      'Email': 's11923787@stu.najah.edu'
    },
 
  ].obs;
  
final RxList<Map<String, String>> educationLevels =
      <Map<String, String>>[


  ].obs;

  final RxList<Map<String, String>> practicalExperiences =
      <Map<String, String>>[


  ].obs;
// for profile
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;

  // for cover page
  // for cover image 
final RxString coverImageBytes = ''.obs;
final RxString coverImageBytesName = ''.obs;
final RxString coverImageExt = ''.obs;





  // get data from database


 /* goToAboutInfo() {
   // Get.to(SeeAboutInfo());



   /*  Get.to(
        SeeAboutInfo(),
        arguments: {'personalDetails': PersonalDetails},
      );*/
        Get.to(
    SeeAboutInfo(),
    arguments: {
      'personalDetails': PersonalDetails,
      'educationLevels': educationLevels,
      'practicalExperiences': practicalExperiences,
    },
  );*/

  getEducationLevel() async {
var url = urlStarter + "/user/getEducationLevel?email=$Email";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    print(responce);
    return responce;
}
  goToEducationLevel() async {
    var res = await getEducationLevel();
    var resbody = jsonDecode(res.body);
    if(res.statusCode == 409 || res.statusCode == 500){
      return resbody['message'];
    }else if(res.statusCode == 200){
    var responseBody = jsonDecode(res.body);
    print(responseBody);
    var EducationLevel = (responseBody['educationLevel'] as List<dynamic>)
        .map((dynamic experience) =>
            Map<String, String>.from(experience as Map<String, dynamic>))
        .toList();
    print(EducationLevel);
    educationLevels.assignAll(EducationLevel);
   /* Get.to(
        SeeAboutInfo(),
        arguments: {'educationLevel': EducationLevel},
      );*/
      
    } 

   
  }

  ///////////////////////////////////////////
    Future getWorkExperiencePgae() async {
    var url = urlStarter + "/user/getworkExperience?email=$Email";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    print(responce);
    return responce;
  }

  goToWorkExperiencePgae()async{
    var res = await getWorkExperiencePgae();
    var resbody = jsonDecode(res.body);
    if(res.statusCode == 409 || res.statusCode == 500){
      return resbody['message'];
    }else if(res.statusCode == 200){
    var responseBody = jsonDecode(res.body);
    print(responseBody);
    var workExperiences = (responseBody['workExperiences'] as List<dynamic>)
        .map((dynamic experience) =>
            Map<String, String>.from(experience as Map<String, dynamic>))
        .toList();
    print(workExperiences);
    practicalExperiences.assignAll(workExperiences);
   /* Get.to(
        WorkExperience(),
        arguments: {'workExperiences': workExperiences},
      );*/

      
    } 
  }
  /////////////////////////////////////////


  goToAboutInfo()async {
   // Get.to(SeeAboutInfo());



   /*  Get.to(
        SeeAboutInfo(),
        arguments: {'personalDetails': PersonalDetails},
      );*/
      goToWorkExperiencePgae();
      goToEducationLevel();
        Get.to(
    SeeAboutInfo(),
    arguments: {

      
      
      'educationLevel': educationLevels,
      'practicalExperiences': practicalExperiences,
     // 'PersonalDetails':PersonalDetails,

      
    },
  );}
      

  





  



}