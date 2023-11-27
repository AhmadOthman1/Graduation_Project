import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Like extends StatelessWidget {
   Like({super.key});
    final List<Map<String, dynamic>> Likes = [
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

    {
      'name': 'Obaida Aws',
      'jobTitle': 'Software Engineer',
      'image': 'images/obaida.jpeg',
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

    {
      'name': 'Obaida Aws',
      'jobTitle': 'Software Engineer',
      'image': 'images/obaida.jpeg',
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

    {
      'name': 'Obaida Aws',
      'jobTitle': 'Software Engineer',
      'image': 'images/obaida.jpeg',
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

    {
      'name': 'Obaida Aws',
      'jobTitle': 'Software Engineer',
      'image': 'images/obaida.jpeg',
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

    {
      'name': 'Obaida Aws',
      'jobTitle': 'Software Engineer',
      'image': 'images/obaida.jpeg',
      'deleteIcon': Icons.delete,
      'messageIcon': Icons.message,
    },

    {
      'name': 'Obaida Aws',
      'jobTitle': 'Software Engineer',
      'image': 'images/obaida.jpeg',

    },

    {
      'name': 'Obaida Aws',
      'jobTitle': 'Software Engineer',
      'image': 'images/obaida.jpeg',
    
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
                      "Likes",
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
              itemCount: Likes.length,
              itemBuilder: (context, index) {
                final colleague = Likes[index];

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