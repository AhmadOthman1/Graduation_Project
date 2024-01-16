import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/ColleaguesProfile_controller.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/JobsPages/showthejob.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchControllerImp controller = Get.put(SearchControllerImp());
  final ColleaguesProfileControllerImp _controller2 =
      Get.put(ColleaguesProfileControllerImp());
  final GlobalKey<FormState> formstate = GlobalKey();
  bool isLoading = false;
  var searchType = "U";
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  ImageProvider<Object>? profileBackgroundImage;
  String? profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
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
                        child: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        onTap: () {
                          if (formstate.currentState!.validate()) {
                            setState(() {
                              isLoading = false;
                              controller.Upage = 1;
                              controller.userList.clear();
                              controller.pageList.clear();
                              controller.jobeList.clear();
                            });
                            print(searchType);
                            controller.goTosearchPage(controller.searchValue,
                                controller.Upage, searchType);
                          } else {
                            print("Not Valid");
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      controller.searchValue = value;
                      if (value == null || value.isEmpty) {
                        return "";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
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
                  onTap: (index) {
                    // Handle tab click here
                    if (index == 0) {
                      searchType = "U";
                      print('Users Tab clicked!');
                    } else if (index == 1) {
                      searchType = "P";
                      print('Pages Tab clicked!');
                    } else if (index == 2) {
                      searchType = "J";
                      print('Jobs Tab clicked!');
                    }
                  },
                  tabs: [
                    Tab(
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color.fromARGB(255, 85, 191, 218),
                            width: 1,
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text("Users"),
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
                            width: 1,
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text("Pages"),
                        ),
                      ),
                    ),
                    // for jobs

                    Tab(
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color.fromARGB(255, 85, 191, 218),
                            width: 1,
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text("Jobs"),
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
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      var currentPos = scrollInfo.metrics.pixels;
                      var maxPos = scrollInfo.metrics.maxScrollExtent;
                      //print(currentPos);
                      //print(maxPos);
                      if (!isLoading && currentPos == maxPos) {
                        setState(() {
                          isLoading =
                              true; // Set loading to true to avoid multiple requests
                          controller.Upage++;
                        });

                        controller
                            .goTosearchPage(
                                controller.searchValue, controller.Upage, "U")
                            .then((result) async {
                          if (result != null && result.isNotEmpty) {
                            await Future.delayed(const Duration(
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
                        // for user

                        padding: const EdgeInsets.all(15),
                        itemCount: controller.userList.length,
                        itemBuilder: (context, index) {
                          final firstname =
                              controller.userList[index]['firstname'];
                          final lastname =
                              controller.userList[index]['lastname'];
                          final username =
                              controller.userList[index]['username'];
                          final photo = controller.userList[index]['photo'];
                          profileBackgroundImage =
                              (photo != null && photo != "null" && photo != "")
                                  ? Image.network("$urlStarter/$photo").image
                                  : defultprofileImage;
                          return ListTile(
                            onTap: () {
                              final userUsername = username;
                              final userFirstname = firstname;
                              final userLastname = lastname;
                              final userPhoto = photo;

                              Map<String, dynamic> userMap = {
                                'name': '$userFirstname $userLastname',
                                'username': userUsername,
                                'photo': userPhoto,
                                'type': 'U'
                              };

                              _controller2.colleaguesmessages.assign(userMap);
                              print(
                                  "lllllllllllllllllllllllllllllllllllllllll");
                              print(_controller2.colleaguesmessages);
                              print(
                                  "lllllllllllllllllllllllllllllllllllllllll");

                              controller.goToUserPage(userUsername!);
                              //  controller.goToprofile(email)
                            },
                            title: Text('$firstname $lastname'),
                            subtitle: Text('$username'),
                            trailing: CircleAvatar(
                              backgroundImage: profileBackgroundImage,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      var currentPos = scrollInfo.metrics.pixels;
                      var maxPos = scrollInfo.metrics.maxScrollExtent;
                      //print(currentPos);
                      //print(maxPos);
                      if (!isLoading && currentPos == maxPos) {
                        setState(() {
                          isLoading =
                              true; // Set loading to true to avoid multiple requests
                          controller.Upage++;
                        });

                        controller
                            .goTosearchPage(
                                controller.searchValue, controller.Upage, "P")
                            .then((result) async {
                          if (result != null && result.isNotEmpty) {
                            await Future.delayed(const Duration(
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
                        // for user

                        padding: const EdgeInsets.all(15),
                        itemCount: controller.pageList.length,
                        itemBuilder: (context, index) {
                          final name = controller.pageList[index]['name'];
                          final pageId = controller.pageList[index]['id'];
                          final photo = controller.pageList[index]['photo'];
                          profileBackgroundImage =
                              (photo != null && photo != "null" && photo != "")
                                  ? Image.network("$urlStarter/$photo").image
                                  : defultprofileImage;
                          return ListTile(
                            onTap: () {
                              controller.goToPage(pageId!);
                            },
                            title: Text('$name'),
                            subtitle: Text('$pageId'),
                            trailing: CircleAvatar(
                              backgroundImage: profileBackgroundImage,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // jobbbbbsssssss
                  // for jobssssss
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      var currentPos = scrollInfo.metrics.pixels;
                      var maxPos = scrollInfo.metrics.maxScrollExtent;
                      //print(currentPos);
                      //print(maxPos);
                      if (!isLoading && currentPos == maxPos) {
                        setState(() {
                          isLoading =
                              true; // Set loading to true to avoid multiple requests
                          controller.Upage++;
                        });

                        controller
                            .goTosearchPage(
                                controller.searchValue, controller.Upage, "J")
                            .then((result) async {
                          if (result != null && result.isNotEmpty) {
                            await Future.delayed(const Duration(
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
                        // for user

                        padding: const EdgeInsets.all(15),
                        itemCount: controller.jobeList.length,
                        itemBuilder: (context, index) {
                          final title = controller.jobeList[index]['title'];
                          final Fields = controller.jobeList[index]['Fields'];
                          final pageId = controller.jobeList[index]['pageId'];
                          final jobId = controller.jobeList[index]['pageJobId'];

                          return ListTile(
                            onTap: () {
                              Get.to(ShowTheJob(
                                jopId: jobId,
                                title: title!,
                                company: pageId!,
                                Fields: Fields!,
                                image: controller.jobeList[index]['photo'],
                                deadline: controller.jobeList[index]['endDate']!,
                                content: controller.jobeList[index]
                                    ['description']!,
                              ));
                            },
                            title: Text('$title'),
                            subtitle: Text('$Fields'),
                            trailing: Text('$pageId'),
                          );
                        },
                      ),
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
