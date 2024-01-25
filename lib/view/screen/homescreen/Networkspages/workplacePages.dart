import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/controller/home/network_controller/showWorkPlacePages_controller.dart';
import 'package:growify/controller/home/network_controller/showcolleagues_controller.dart';
import 'package:growify/controller/home/network_controller/showpagesiFollow_controller.dart';
import 'package:growify/global.dart';

class ShowMyWorkPlacePages extends StatefulWidget {
  const ShowMyWorkPlacePages({Key? key}) : super(key: key);

  @override
  _ShowMyWorkPlacePagesState createState() => _ShowMyWorkPlacePagesState();
}

final ScrollController scrollController = ScrollController();

class _ShowMyWorkPlacePagesState extends State<ShowMyWorkPlacePages> {
  final NetworkMainPageControllerImp Networkcontroller =
      Get.put(NetworkMainPageControllerImp());
  late ShowMyWorkPlacePagesController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");

  @override
  void initState() {
    super.initState();
    _controller = ShowMyWorkPlacePagesController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadPages(_controller.page);
      setState(() {
        _controller.page++;
        _controller.WorkPlacePages;
      });
      print('Data loaded: ${_controller.WorkPlacePages.length} Pages');
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Workplace Pages'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 2, child: Container()),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes the position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Divider(
                      color: Color.fromARGB(255, 194, 193, 193),
                      thickness: 2.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _controller.WorkPlacePages.length,
                        itemBuilder: (context, index) {
                          final pageFollowed =
                              _controller.WorkPlacePages[index];
                          final firstname = pageFollowed['name'];

                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  final pageId = pageFollowed['id'];
                                  Networkcontroller.goToPage(pageId!);
                                },
                                leading: CircleAvatar(
                                  backgroundImage:
                                      (pageFollowed['photo'] != null &&
                                              pageFollowed['photo'] != "")
                                          ? Image.network("$urlStarter/" +
                                                  pageFollowed['photo']!)
                                              .image
                                          : defultprofileImage,
                                ),
                                title: Text(
                                  '$firstname ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                    if (_controller.isLoading)
                      const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
            Expanded(flex: 2, child: Container()),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Workplace Pages'),
        ),
        body: Column(
          children: [
            const Divider(
              color: Color.fromARGB(255, 194, 193, 193),
              thickness: 2.0,
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _controller.WorkPlacePages.length,
                itemBuilder: (context, index) {
                  final pageFollowed = _controller.WorkPlacePages[index];
                  final firstname = pageFollowed['name'];

                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          final pageId = pageFollowed['id'];
                          Networkcontroller.goToPage(pageId!);
                        },
                        leading: CircleAvatar(
                          backgroundImage: (pageFollowed['photo'] != null &&
                                  pageFollowed['photo'] != "")
                              ? Image.network(
                                      "$urlStarter/" + pageFollowed['photo']!)
                                  .image
                              : defultprofileImage,
                        ),
                        title: Text(
                          '$firstname ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
            if (_controller.isLoading) const CircularProgressIndicator(),
          ],
        ),
      );
    }
  }
}
