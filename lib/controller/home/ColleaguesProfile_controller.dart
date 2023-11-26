

import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/profilepages/seeaboutInfoColleagues.dart';

class ColleaguesProfileControllerImp extends GetxController {

  

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
    {
      'Specialty': 'Project Manager',
      'School': '123 Projects',
      'Description': 'Managing various projects',
      'Start Date': '2020-03-10',
      'End Date': '2021-06-10',
    },
    {
      'Specialty': 'Data Analyst',
      'School': 'Data Insights',
      'Description': 'Analyzing and interpreting data',
      'Start Date': '2019-09-05',
      'End Date': '2020-03-05',
    },
    {
      'Specialty': 'Marketing Specialist',
      'School': 'Marketing Pro',
      'Description': 'Executing marketing campaigns',
      'Start Date': '2018-04-20',
      'End Date': '2019-09-20',
    },

       {
      'Specialty': 'Marketing Specialist',
      'School': 'Marketing Pro',
      'Description': 'Executing marketing campaigns',
      'Start Date': '2018-04-20',
      'End Date': '2019-09-20',
    },

       {
      'Specialty': 'Marketing Specialist',
      'School': 'Marketing Pro',
      'Description': 'Executing marketing campaigns',
      'Start Date': '2018-04-20',
      'End Date': '2019-09-20',
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
    {
      'Specialty': 'Project Manager',
      'Company': '123 Projects',
      'Description': 'Managing various projects',
      'Start Date': '2020-03-10',
      'End Date': '2021-06-10',
    },
    {
      'Specialty': 'Data Analyst',
      'Company': 'Data Insights',
      'Description': 'Analyzing and interpreting data',
      'Start Date': '2019-09-05',
      'End Date': '2020-03-05',
    },
    {
      'Specialty': 'Marketing Specialist',
      'Company': 'Marketing Pro',
      'Description': 'Executing marketing campaigns',
      'Start Date': '2018-04-20',
      'End Date': '2019-09-20',
    },
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


  goToAboutInfo() {
   // Get.to(SeeAboutInfo());



   /*  Get.to(
        SeeAboutInfo(),
        arguments: {'personalDetails': PersonalDetails},
      );*/
        Get.to(
    SeeAboutInfoColleagues(),
    arguments: {
      'personalDetails': PersonalDetails,
      'educationLevels': educationLevels,
      'practicalExperiences': practicalExperiences,
    },
  );


  
}}