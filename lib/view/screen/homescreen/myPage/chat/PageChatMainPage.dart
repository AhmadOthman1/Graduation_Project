import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/myPage_Controller/chat_controller/pageChatmainpage_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/chat/chatpagemessages.dart';
import 'package:growify/view/screen/homescreen/myPage/chat/pageChatpagemessages.dart';

class PageChatMainPage extends StatefulWidget {
  const PageChatMainPage({Key? key , required this.pageId, required this.pageName, required this.pagePhoto}) : super(key: key);
  final String pageId;
  final pageName;
  final pagePhoto;
  @override
  _PageChatMainPageState createState() => _PageChatMainPageState();
}

class _PageChatMainPageState extends State<PageChatMainPage> {
  final PageChatMainPageController controller = Get.put(PageChatMainPageController());
  @override
  void initState() {
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
                  onTap: () async {
                    var pageAccessToken= await controller.generatePageAccessToken(widget.pageId);
                    Get.to(pageChatpagemessages(
                      data: controller.colleaguesPreviousmessages[index],pageId:widget.pageId,pageName:widget.pageName,pagePhoto:widget.pagePhoto,pageAccessToken:pageAccessToken
                      
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
