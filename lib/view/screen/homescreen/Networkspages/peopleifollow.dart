import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';

class PeopleIFollow extends StatelessWidget {
   PeopleIFollow({super.key});
   final List<Map<String, dynamic>> peopleifollow = [
    {
      'name': 'Islam Aws',
      'jobTitle': 'UI Designer',
      'image': 'images/islam.jpeg',
      'messageIcon': Icons.more_vert,
    },
    {
      'name': 'Obaida Aws',
      'jobTitle': 'Software Engineer',
      'image': 'images/obaida.jpeg',
      'messageIcon': Icons.more_vert,
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
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    )),
                // put the icons action
                Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "People I Follow",
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
              itemCount: peopleifollow.length,
              itemBuilder: (context, index) {
                final followed = peopleifollow[index];

                return Column(
                  children: [
                    ListTile(
                      leading: InkWell(
                        onTap: (){
                          Get.to(ColleaguesProfile());
                        },
                        child: CircleAvatar(
                          backgroundImage: AssetImage(followed['image']),
                        ),
                      ),
                      title: Text(followed['name']),
                      subtitle: Text(followed['jobTitle']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                         
                          IconButton(
                            icon: Icon(followed['messageIcon']),
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