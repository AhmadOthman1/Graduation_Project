import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/Networkspages/showpage.dart';

class Pages extends StatelessWidget {
   Pages({super.key});

   final List<Map<String, dynamic>> pages = [
    {
      'name': 'Flutter Dev',
      'Followers': '43,465 follower',
      'image': 'images/flutterimage.png',
      'messageIcon': Icons.more_vert,
    },
    {
      'name': 'Netflix',
      'Followers': '22,187 follower',
      'image': 'images/Netflix.png',
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
            margin: const EdgeInsets.only(top: 50, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(onPressed: (){
                  Get.back();
                }, icon: const Icon(Icons.arrow_back,size: 30,)),
                // put the icons action
                Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text(
                      "Pages",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(width: 180,),
                
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pages.length,
              itemBuilder: (context, index) {
                final page = pages[index];

                return Column(
                  children: [
                    ListTile(
                      leading: InkWell(
                        onTap: (){
                          Get.to(const ShowPage());
                        },
                        child: CircleAvatar(
                          backgroundImage: AssetImage(page['image']),
                        ),
                      ),
                      title: Text(page['name']),
                      subtitle: Text(page['Followers']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(page['messageIcon']),
                            onPressed: () {
                              // Add send message logic here
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(
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