import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/Networkspages/showgroup.dart';

class GroupsPage extends StatelessWidget {
  GroupsPage({super.key});

  final List<Map<String, dynamic>> groups = [
    {
      'name': 'MySQL',
      'Members': '263,400 member',
      'image': 'images/mysql.jpg',
      'messageIcon': Icons.more_vert,
    },
    {
      'name': 'Software Developer',
      'Members': '112,253 member',
      'image': 'images/software.jpg',
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
                IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back,size: 30,)),
                // put the icons action
                Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Groups",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                SizedBox(width: 180,),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Create",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ))
              ],
            ),
          ),
          Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];

                return Column(
                  children: [
                    ListTile(
                      leading: InkWell(
                        onTap: (){
                          Get.to(ShowGroup());
                        },
                        child: CircleAvatar(
                          backgroundImage: AssetImage(group['image']),
                        ),
                      ),
                      title: Text(group['name']),
                      subtitle: Text(group['Members']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(group['messageIcon']),
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
