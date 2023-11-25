import 'package:flutter/material.dart';
import 'package:growify/controller/home/myPages_controller.dart';
import 'package:growify/view/screen/homescreen/settings/createPage.dart';
import 'package:get/get.dart';

class MyPages extends StatelessWidget {
  final MyPagesController controller = MyPagesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Pages",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          
          TextButton(
            onPressed: () {
              Get.to(CreatePage());
            },
            child: Text(
              "Create",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<PageInfo>?>(
          future: controller.getMyPagesData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<PageInfo>? pages = snapshot.data;

              if (pages == null || pages.isEmpty) {
                return Text('You don\'t have any pages.');
              }

              return ListView.builder(
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the corresponding page with the id
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageDetails(pages[index].id),
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Image.network(pages[index].image),
                          Text(pages[index].name),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class PageDetails extends StatelessWidget {
  final int pageId;

  PageDetails(this.pageId);

  @override
  Widget build(BuildContext context) {
    // Implement your page details UI using the pageId
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Details'),
      ),
      body: Center(
        child: Text('Details for Page ID: $pageId'),
      ),
    );
  }
}
