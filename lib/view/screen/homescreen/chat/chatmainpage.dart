import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/chats_controller/chatmainpage_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/chat/chatpagemessages.dart';

class ChatMainPage extends StatefulWidget {
  const ChatMainPage({Key? key}) : super(key: key);

  @override
  _ChatMainPageState createState() => _ChatMainPageState();
}

class _ChatMainPageState extends State<ChatMainPage> {
  final ChatMainPageController controller = Get.put(ChatMainPageController());
  @override
  void initState() {
    controller.localColleagues.clear();
    controller.localColleagues.assignAll(Get.arguments['Mycolleagues']);

    controller.localColleagues
        .sort((a, b) => a['firstname'].compareTo(b['firstname']));

    RxList<Map<String, dynamic>>.from(
        Get.arguments['colleaguesPreviousmessages']);

    controller.colleaguesPreviousmessages
        .assignAll(Get.arguments['colleaguesPreviousmessages']);
    print(controller.colleaguesPreviousmessages);
    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const Drawer(),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(Icons.chat_rounded,color: Colors.black,),
            Text(
              " Chats ",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        //centerTitle: true,
        backgroundColor: Colors.grey[200],
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          // Search bar and Active colleagues section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                const Text(
                  "Active colleagues",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: controller.localColleagues.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(ChatPageMessages(
                            data: controller.localColleagues[index],
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey[200],
                                        backgroundImage: (controller
                                                        .localColleagues[index]
                                                    ["photo"] !=
                                                null)
                                            ? Image.network(
                                                    "$urlStarter/${controller.localColleagues[index]['photo']}")
                                                .image
                                            : const AssetImage(
                                                "images/profileImage.jpg"),
                                      ),
                                      const Positioned(
                                        bottom: 2,
                                        right: 2,
                                        child: CircleAvatar(
                                          radius: 8,
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "@${controller.localColleagues[index]["username"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Text(
                  "Conversations",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),

          // Pages section

          // List of pages

          Obx(
            () => ListView.builder(
              itemCount: controller.colleaguesPreviousmessages.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                // final cate = Categories[index];
                // ok
                return InkWell(
                  onTap: () {
                    Get.to(ChatPageMessages(
                      data: controller.colleaguesPreviousmessages[index],
                      
                    ));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: (controller
                                  .colleaguesPreviousmessages[index]["photo"] !=
                              null)
                          ? Image.network(
                                  "$urlStarter/${controller.colleaguesPreviousmessages[index]['photo']}")
                              .image
                          : const AssetImage("images/profileImage.jpg"),
                    ),
                    title: Text(
                        controller.colleaguesPreviousmessages[index]['name']),
                    subtitle: Text("@${controller.colleaguesPreviousmessages[index]
                        ['username']}"),
                    
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
