import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/view/screen/homescreen/JobsPages/showthejob.dart';
import 'package:growify/view/screen/homescreen/homepages/homemainPage.dart';

class JobsPage extends StatelessWidget {
  JobsPage({super.key});

  final List<Map<String, dynamic>> jobs = [
    {
      'Position': 'Technical support engineer',
      'Company': 'Harri',
      'location': 'Ramallah',
      'image': 'images/islam.jpeg',
      'messageIcon': Icons.bookmark_outline,
      'applicants1': 12, // First 12 applicants
    },
    {
      'Position': 'Call for Technical Experts',
      'Company': 'DAI',
      'location': 'Nablus',
      'image': 'images/obaida.jpeg',
      'messageIcon': Icons.bookmark_outline,
      'applicants1': 9, // First 9 applicants
    },

        {
      'Position': 'Call for Technical Experts',
      'Company': 'DAI',
      'location': 'Nablus',
      'image': 'images/obaida.jpeg',
      'messageIcon': Icons.bookmark_outline,
      'applicants1': 9, // First 9 applicants
    },

         {
      'Position': 'Technical support engineer',
      'Company': 'Harri',
      'location': 'Ramallah',
      'image': 'images/islam.jpeg',
      'messageIcon': Icons.bookmark_outline,
      'applicants1': 12, // First 12 applicants
    },

        {
      'Position': 'Call for Technical Experts',
      'Company': 'DAI',
      'location': 'Nablus',
      'image': 'images/obaida.jpeg',
      'messageIcon': Icons.bookmark_outline,
      'applicants1': 9, // First 9 applicants
    },

        {
      'Position': 'Call for Technical Experts',
      'Company': 'DAI',
      'location': 'Nablus',
      'image': 'images/obaida.jpeg',
      'messageIcon': Icons.bookmark_outline,
      'applicants1': 9, // First 9 applicants
    },


         {
      'Position': 'Technical support engineer',
      'Company': 'Harri',
      'location': 'Ramallah',
      'image': 'images/islam.jpeg',
      'messageIcon': Icons.bookmark_outline,
      'applicants1': 12, // First 12 applicants
    },

        {
      'Position': 'Call for Technical Experts',
      'Company': 'DAI',
      'location': 'Nablus',
      'image': 'images/obaida.jpeg',
      'messageIcon': Icons.bookmark_outline,
      'applicants1': 9, // First 9 applicants
    },

        {
      'Position': 'Call for Technical Experts',
      'Company': 'DAI',
      'location': 'Nablus',
      'image': 'images/obaida.jpeg',
      'messageIcon': Icons.bookmark_outline,
      'applicants1': 9, // First 9 applicants
    },

         {
      'Position': 'Technical support engineer',
      'Company': 'Harri',
      'location': 'Ramallah',
      'image': 'images/islam.jpeg',
      'messageIcon': Icons.bookmark_outline,
      'applicants1': 12, // First 12 applicants
    },
    // Add more job listings as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                   
                  },
                  icon: Icon(Icons.arrow_back, size: 30),
                ),
                // put the icons action
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Jobs",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 180),
              ],
            ),
          ),
          Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];

                return Column(
                  children: [
                    ListTile(
                      leading: InkWell(
                        onTap: (){
                          Get.to(ShowJob());
                        },
                        child: Container(
                          width: 60, // Set your desired width
                          height: 60, // Set your desired height
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                            child: Image.asset(
                              job['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      title: Text(job['Position']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(job['Company']),
                          Text('${job['applicants1']} applicants for the job'),
                          Text(job['location']),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(job['messageIcon']),
                            onPressed: () {
                              // Add send message logic here
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Color.fromARGB(255, 194, 193, 193),
                      thickness: 2.0,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
