import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/SeeAboutInfo_Controller.dart';

class SeeAboutInfo extends StatelessWidget {
   SeeAboutInfo({super.key});
  final SeeAboutInfoController controller = Get.put(SeeAboutInfoController());

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Container(child: Text("obaida"),),
          _buildPersonalDetails(controller),
        ],
      ),
    );
  }

    Widget _buildPersonalDetails(SeeAboutInfoController controller) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: controller.personalData.asMap().entries.map((entry) {
          final index = entry.key;
          final information = entry.value;

          return Column(
            children: [
              ListTile(
                title: Text('Name: ${information['Specialty']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Company: ${information['Company']}'),
                    Text('Description: ${information['Description']}'),
                    Text('Start Date: ${information['Start Date']}'),
                    Text('End Date: ${information['End Date']}'),
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
    });
  }

  
}