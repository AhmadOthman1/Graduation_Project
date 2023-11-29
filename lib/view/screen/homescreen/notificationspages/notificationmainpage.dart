import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
   NotificationsPage({super.key});

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New poll in MYSQL about how many computer engineer like his position ',
      'time': 'Before ${2} minutes',
      'image': 'images/islam.jpeg',
      'messageIcon': Icons.more_vert,
    },
    {
      'title': 'Obaida Aws Post published about the recent events in the Gaza Strip, and about Israeli terrorism.',
      'time': 'Before ${1} hour',
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
            margin: const EdgeInsets.only(top: 50, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back,size: 30,)),
                // put the icons action
                Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text(
                      "Notices",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
               
                
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notices = notifications[index];

                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(notices['image']),
                      ),
                      title: Text(notices['title']),
                      subtitle: Text(notices['time']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(notices['messageIcon']),
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