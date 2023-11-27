import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class Search extends StatelessWidget {
  final SearchControllerImp controller = Get.put(SearchControllerImp());
  GlobalKey<FormState> formstate = GlobalKey();

  final AssetImage defultprofileImage = AssetImage("images/profileImage.jpg");
  ImageProvider<Object>? profileBackgroundImage;
  String? profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.black,),
            onPressed: () {
              Get.back(); // Navigate back
            },
          ),
          title: Form(
            key: formstate,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 7),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      suffixIcon: InkWell(
                        child: const Icon(Icons.search,color: Colors.black,),
                        onTap: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
             
                if (formstate.currentState!.validate()) {
                  controller.searchInDataBase();
                  print("Valid");
                } else {
                  print("Not Valid");
                }
              },
              child: const Text(
                'Search',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Material(
              child: Container(
                height: 55,
                color: Colors.white,
                child: TabBar(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  unselectedLabelColor: const Color.fromARGB(255, 85, 191, 218),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 85, 191, 218),
                  ),
                  tabs: [
                    Tab(
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: const Color.fromARGB(255, 85, 191, 218),
                              width: 1),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: const Text("Users"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: const Color.fromARGB(255, 85, 191, 218),
                              width: 1),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: const Text("Pages"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Obx(
                    () => ListView.separated(
                      // for user

                      padding: const EdgeInsets.all(15),
                      itemCount: controller.userList.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (context, index) {
                        final name = controller.userList[index]['name'];
                        final username = controller.userList[index]['username'];
                        final imageUrl = controller.userList[index]['imageUrl'];

                        return ListTile(
                          onTap: () {
                           final email=controller.userList[index]['email'];
                            controller.goToProfileColleaguesPage(email!);
                          //  controller.goToprofile(email)
                          },
                          title: Text('$name'),
                          subtitle: Text('$username'),
                          trailing: CircleAvatar(
                            backgroundImage: AssetImage('$imageUrl'),
                          ),
                        );
                      },
                    ),
                  ),
                  Obx(
                    () => ListView.separated(
                      padding: const EdgeInsets.all(15),
                      itemCount: controller.pageList.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (context, index) {
                        final name = controller.pageList[index]['name'];
                        final username = controller.pageList[index]['username'];
                        final imageUrl = controller.pageList[index]['imageUrl'];

                        // we you git from database active this to check if null
                        //profileImage = (controller.pageList[index]['imageUrl'] == null) ? "" : controller.pageList[index]['imageUrl'];
                        /*     profileBackgroundImage = (profileImage != null && profileImage != "")
        ? Image.network(urlStarter + "/" + profileImage!).image
        : defultprofileImage;

                        */
                        /*
                         CircleAvatar(
            
            backgroundImage: controller.profileImageBytes.isNotEmpty
                ? MemoryImage(base64Decode(controller.profileImageBytes.value))
                : profileBackgroundImage, // Replace with your default photo URL
          ),


                        */

                        return ListTile(
                          onTap: () {},
                          title: Text('$name'),
                          subtitle: Text('$username'),
                          trailing: CircleAvatar(
                            backgroundImage: AssetImage('$imageUrl'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
