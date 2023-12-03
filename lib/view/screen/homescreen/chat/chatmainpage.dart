import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/chats_controller/chatmainpage_controller.dart';
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
    controller.localColleagues =
        RxList<Map<String, dynamic>>.from(Get.arguments['Mycolleagues']);

    controller.localColleagues.sort((a, b) => a['name'].compareTo(b['name']));
   
            RxList<Map<String, dynamic>>.from(Get.arguments['colleaguesPreviousmessages']);

    controller.colleaguesPreviousmessages.assignAll(Get.arguments['colleaguesPreviousmessages']);
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
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
      ),
      body: ListView(
        children: [
          // Search bar and Active colleagues section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search",
                  ),
                ),
                const SizedBox(height: 30),
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
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: AssetImage(
                                    controller.localColleagues[index]["image"]),
                              ),
                            ),
                            Text(
                              controller.localColleagues[index]["name"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Pages section

          // List of pages

          NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                      var currentPos = scrollInfo.metrics.pixels;
                      var maxPos = scrollInfo.metrics.maxScrollExtent;

                      if (!isLoading && currentPos == maxPos) {
                        setState(() {
                          isLoading =
                              true; // Set loading to true to avoid multiple requests
                          controller.Upage++;
                        });

                        controller
                            .getColleaguesfromDataBase()
                            .then((result) async {
                          if (result != null && result.isNotEmpty) {
                            await Future.delayed(Duration(
                                seconds:
                                    1)); // to solve the problem when the user reach the bottom of the page1, it fetch page 3,4,5...etc.
                            setState(() {
                              isLoading =
                                  false; // Reset loading when the data is fetched
                            });
                            print(isLoading);
                          }
                        });
                      }
                      return false;
                    },
            child: Obx(
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
                        backgroundImage: AssetImage(
                            controller.colleaguesPreviousmessages[index]['image']),
                      ),
                      title: Text(controller.colleaguesPreviousmessages[index]['name']),
                      subtitle:
                          Text(controller.colleaguesPreviousmessages[index]['message']),
                      trailing: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (String option) {
                                controller.onMoreOptionSelected(option);
                              },
                              itemBuilder: (BuildContext context) {
                                return controller.moreOptions.map((String option) {
                                  return PopupMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList();
                              },
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
