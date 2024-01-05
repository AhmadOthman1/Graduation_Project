import 'package:flutter/material.dart';
import 'package:growify/controller/home/SeeAboutInfo_Controller.dart';

class MyPageSeeAboutInfo extends StatelessWidget {
  final dynamic userData;

  MyPageSeeAboutInfo({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Info",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPersonalDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDetails() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 5),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Personal Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromRGBO(14, 89, 108, 1),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Color.fromARGB(255, 194, 193, 193),
                  thickness: 2.0,
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          _buildDetail("Name", userData[0]['name']),
          _buildDetail("Description", userData[0]['description']),
          _buildDetail("Address", userData[0]['address']),
          _buildDetail("ContactInfo", userData[0]['contactInfo']),
          _buildDetail("Country", userData[0]['country']),
          _buildDetail("Speciality", userData[0]['speciality']),
          _buildDetail("PageType", userData[0]['pageType']),
        ],
      ),
    );
  }

  Widget _buildDetail(String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          value ?? '', 
          style: TextStyle(color: Colors.grey[800]),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
