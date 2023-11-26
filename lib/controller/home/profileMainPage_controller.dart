import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:growify/view/screen/homescreen/profilepages/seeAboutinfo.dart';



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
    {
      'Specialty': 'Software Developer',
      'School': 'ABC Tech',
      'Description': 'Developing awesome apps',
      'Start Date': '2022-01-01',
      'End Date': '2022-12-31',
    },
    {
      'Specialty': 'UI/UX Designer',
      'School': 'XYZ Design',
      'Description': 'Creating beautiful interfaces',
      'Start Date': '2021-06-15',
      'End Date': '2022-01-15',
    },

  ].obs;

  final RxList<Map<String, String>> practicalExperiences =
      <Map<String, String>>[
    {
      'Specialty': 'Software Developer',
      'Company': 'ABC Tech',
      'Description': 'Developing awesome apps',
      'Start Date': '2022-01-01',
      'End Date': '2022-12-31',
    },
    {
      'Specialty': 'UI/UX Designer',
      'Company': 'XYZ Design',
      'Description': 'Creating beautiful interfaces',
      'Start Date': '2021-06-15',
      'End Date': '2022-01-15',
    },

  ].obs;





  // get data from database


  goToAboutInfo() {
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
  );
      

  }





  



}