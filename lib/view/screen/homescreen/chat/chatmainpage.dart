import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:growify/view/screen/homescreen/chat/chatpagemessages.dart';

class ChatMainPage extends StatelessWidget {
  ChatMainPage({super.key});

  List Categories = [
    {
      "image": 'images/obaida.jpeg',
      "name": "Obaida",
      "message":"Hi Can i call you",
      'messageIcon': Icons.more_vert,
    },
    {
      "image": 'images/harri.png',
      "name": "Ahmad",
      "message":"Hi Can i call you",
      'messageIcon': Icons.more_vert,
    },
    {
      "image": 'images/islam.jpeg',
      "name": "Islam",
      "message":"Hi Can i call you",
      'messageIcon': Icons.more_vert,
    },
    {
      "image": 'images/Netflix.png',
      "name": "Mousa",
      "message":"Hi Can i call you",
      'messageIcon': Icons.more_vert,
    },
    {
      "image": 'images/flutterimage.png',
      "name": "Osman",
      "message":"Hi Can i call you",
      'messageIcon': Icons.more_vert,
    },
    {
      "image": 'images/obaida.jpeg',
      "name": "Obada",
      "message":"Hi Can i call you",
      'messageIcon': Icons.more_vert,
    },
    {
      "image": 'images/harri.png',
      "name": "Abbas",
      "message":"Hi Can i call you",
      'messageIcon': Icons.more_vert,
    },
    {
      "image": 'images/Netflix.png',
      "name": "Mousa",
      "message":"Hi Can i call you",
      'messageIcon': Icons.more_vert,
    },
    {
      "image": 'images/islam.jpeg',
      "name": "Islam",
      "message":"Hi Can i call you",
      'messageIcon': Icons.more_vert,
    },
    {
      "image": 'images/harri.png',
      "name": "Abbas",
      "message":"Hi Can i call you",
      'messageIcon': Icons.more_vert,
    },
  ];


 

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
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
      ),

      body: ListView(
    children: [
      // Search bar and Active colleagues section
      Container(
        padding: EdgeInsets.all(20),
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
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Active colleagues",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20),
            Container(
              height: 100,
              child: ListView.builder(
                itemCount: Categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                   Get.to(ChatPageMessages(data: Categories[index],));

                  },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: AssetImage(Categories[index]["image"]),
                          ),
                        ),
                        Text(
                          Categories[index]["name"],
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
      ListView.builder(
        itemCount: Categories.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
         // final cate = Categories[index];
          return InkWell(
            onTap: (){
                   Get.to(ChatPageMessages(data: Categories[index],));

                  },

            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(Categories[index]['image']),
              ),
              title: Text(Categories[index]['name']),
              subtitle: Text(Categories[index]['message']),
              trailing: IconButton(
                icon: Icon(Categories[index]['messageIcon']),
                onPressed: () {
                  // Handle the message button click
                },
              ),
            ),
          );
        },
      ),
    ],
  ),
      
    );
  }
}
