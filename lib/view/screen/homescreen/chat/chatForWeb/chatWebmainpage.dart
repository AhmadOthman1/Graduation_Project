import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/chats_controller/chatWeb/chatmainpageWeb_controller.dart';
import 'package:growify/controller/home/chats_controller/chatmainpage_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/chat/chatpagemessages.dart';

class ChatWebMainPage extends StatefulWidget {
  const ChatWebMainPage({Key? key}) : super(key: key);

  @override
  _ChatWebMainPageState createState() => _ChatWebMainPageState();
}

class _ChatWebMainPageState extends State<ChatWebMainPage> {
  final ChatMainWebPageController controller =
      Get.put(ChatMainWebPageController());
  bool isLoading = true; // Initialize as true to show loading initially

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // Simulate an asynchronous data fetch operation
    //await Future.delayed(Duration(seconds: 2));

    // Update the data and set isLoading to false

    await controller.goToChat();
    controller.localColleagues.assignAll(controller.MycolleaguesWeb);
    controller.colleaguesPreviousmessages
        .assignAll(controller.colleaguesPreviousmessagesWed);
    isLoading = false;
    print(controller.colleaguesPreviousmessagesWed);
    print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
    setState(()  {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Active colleagues",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.grey[200],
                                              backgroundImage: (controller
                                                              .localColleagues[
                                                          index]["photo"] !=
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => ListView.builder(
                    itemCount: controller.colleaguesPreviousmessages.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
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
                                            .colleaguesPreviousmessages[index]
                                        ["photo"] !=
                                    null)
                                ? Image.network(
                                        "$urlStarter/${controller.colleaguesPreviousmessages[index]['photo']}")
                                    .image
                                : const AssetImage("images/profileImage.jpg"),
                          ),
                          title: Text(controller
                              .colleaguesPreviousmessages[index]['name']),
                          subtitle: Text(
                              "@${controller.colleaguesPreviousmessages[index]['username']}"),
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
