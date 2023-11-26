import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';

class ColleaguesPage extends StatelessWidget {
  ColleaguesPage({super.key});

  final List<Map<String, dynamic>> colleagues = [
    {
      'name': 'Islam Aws',
      'jobTitle': 'UI Designer',
      'image': 'images/islam.jpeg',
      'deleteIcon': Icons.delete,
      'messageIcon': Icons.message,
    },
    {
      'name': 'Obaida Aws',
      'jobTitle': 'Software Engineer',
      'image': 'images/obaida.jpeg',
      'deleteIcon': Icons.delete,
      'messageIcon': Icons.message,
    },
    // Add more colleagues as needed
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
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    )),
                // put the icons action
                Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Colleagues",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: colleagues.length,
              itemBuilder: (context, index) {
                final colleague = colleagues[index];

                return Column(
                  children: [
                    ListTile(
                      leading: InkWell(
                        onTap: (){
                       //   Get.to(ColleaguesProfile());
                        },
                        child: CircleAvatar(
                          backgroundImage: AssetImage(colleague['image']),
                        ),
                      ),
                      title: Text(colleague['name']),
                      subtitle: Text(colleague['jobTitle']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(colleague['deleteIcon']),
                            onPressed: () {
                              // Add delete logic here
                            },
                          ),
                          IconButton(
                            icon: Icon(colleague['messageIcon']),
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
