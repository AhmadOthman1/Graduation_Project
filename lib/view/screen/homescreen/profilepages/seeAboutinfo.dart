import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/SeeAboutInfo_Controller.dart';

class SeeAboutInfo extends StatelessWidget {
  SeeAboutInfo({super.key});
  final SeeAboutInfoController controller = Get.put(SeeAboutInfoController());

  @override
  Widget build(BuildContext context) {
 
    final Map<String, dynamic> arguments = Get.arguments;
    final RxList<Map<String, String>> personalDetails =
        arguments['personalDetails'];
    final RxList<Map<String, String>> educationLevels =
        arguments['educationLevels'];
            final RxList<Map<String, String>> practicalExperiences =
        arguments['practicalExperiences'];


    controller.setpersonalData(personalDetails);
    controller.setEducationLevels(educationLevels);
    controller.setPracticalExperiences(practicalExperiences);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Info",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPersonalDetails(controller),
            _buildEducationList(controller),
            _buildExperienceList(controller),
          ],
        ),
      ),
    );
  }

  ///
  Widget _buildPersonalDetails(SeeAboutInfoController controller) {
    return Container(
   
     margin: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set the border color
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: controller.personalData.asMap().entries.map((entry) {
            final index = entry.key;
            final information = entry.value;

            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Column(
                    children: [
                      Text(
                        "Personal Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Color.fromARGB(255, 194, 193, 193),
                        thickness: 2.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Name: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              '${information['firstName']} ${information['lastName']}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Address: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              '${information['Country']}-${information['Address']}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'userName: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${information['userName']}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Date of Birth: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${information['DateofBirth']}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Email: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${information['Email']}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Phone: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${information['Phone']}'),
                        ],
                      ),
                    ],
                  ),
                ),
                if (index < controller.personalData.length - 1)
                  Divider(
                    color: Color.fromARGB(255, 194, 193, 193),
                    thickness: 1.5,
                  ),
              ],
            );
          }).toList(),
        );
      }),
    );
  }

//
  Widget _buildEducationList(SeeAboutInfoController controller) {
    return Container(
       margin: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set the border color
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
                          Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Column(
                    children: [
                      Text(
                        "Education Levels",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Color.fromARGB(255, 194, 193, 193),
                        thickness: 2.0,
                      ),
                    ],
                  ),
                ),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.educationLevels.asMap().entries.map((entry) {
                final index = entry.key;
                final education = entry.value;

                return Column(
                  children: [
                    
                    ListTile(
                      title: Text('Specialty: ${education['Specialty']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('School: ${education['School']}'),
                          Text('Description: ${education['Description']}'),
                          Text('Start Date: ${education['Start Date']}'),
                          Text('End Date: ${education['End Date']}'),
                        ],
                      ),
                    ),
                    if (index < controller.educationLevels.length - 1)
                      Divider(
                        color: Color.fromARGB(255, 194, 193, 193),
                        thickness: 1.5,
                      ),
                  ],
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
  ///
    Widget _buildExperienceList(SeeAboutInfoController controller) {
    return Container(
             margin: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set the border color
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
           Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Column(
                    children: [
                      Text(
                        "Work Experience",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Color.fromARGB(255, 194, 193, 193),
                        thickness: 2.0,
                      ),
                    ],
                  ),
                ),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.practicalExperiences.asMap().entries.map((entry) {
                final index = entry.key;
                final experience = entry.value;
    
    
                return Column(
                  children: [
                    ListTile(
                      title: Text('Specialty: ${experience['Specialty']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Company: ${experience['Company']}'),
                          Text('Description: ${experience['Description']}'),
                          Text('Start Date: ${experience['Start Date']}'),
                          Text('End Date: ${experience['End Date']}'),
                        ],
                      ),
    
                    ),
                    if (index < controller.practicalExperiences.length - 1)
                      Divider(
                        color: Color.fromARGB(255, 194, 193, 193),
                        thickness: 1.5,
                      ),
                  ],
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
