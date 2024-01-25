import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/controller/home/network_controller/showcolleagues_controller.dart';
import 'package:growify/global.dart';

class ShowColleagues extends StatefulWidget {
  const ShowColleagues({Key? key}) : super(key: key);

  @override
  _ShowColleaguesState createState() => _ShowColleaguesState();
}

final ScrollController scrollController = ScrollController();

class _ShowColleaguesState extends State<ShowColleagues> {
  final NetworkMainPageControllerImp Networkcontroller =
      Get.put(NetworkMainPageControllerImp());
  late ShowColleaguesController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");

  @override
  void initState() {
    super.initState();
    _controller = ShowColleaguesController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadColleagues(_controller.page);
      setState(() {
        _controller.page++;
        _controller.colleagues;
      });
      print('Data loaded: ${_controller.colleagues.length} colleagues');
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
          title: const Text('My Colleagues'),
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
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _controller.colleagues.length,
                        itemBuilder: (context, index) {
                          final colleague = _controller.colleagues[index];
                          final firstname = colleague['firstname'];
                          final lastname = colleague['lastname'];
                          final username = colleague['username'];

                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  final userUsername = username;
                                  Networkcontroller.goToUserPage(userUsername!);
                                },
                                leading: CircleAvatar(
                                  backgroundImage:
                                      (colleague['photo'] != null &&
                                              colleague['photo'] != "")
                                          ? Image.network("$urlStarter/" +
                                                  colleague['photo']!)
                                              .image
                                          : defultprofileImage,
                                ),
                                title: Text('$firstname $lastname'),
                                subtitle: Text('$username'),
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
          title: const Text('My Colleagues'),
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
                itemCount: _controller.colleagues.length,
                itemBuilder: (context, index) {
                  final colleague = _controller.colleagues[index];
                  final firstname = colleague['firstname'];
                  final lastname = colleague['lastname'];
                  final username = colleague['username'];

                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          final userUsername = username;
                          Networkcontroller.goToUserPage(userUsername!);
                        },
                        leading: CircleAvatar(
                          backgroundImage: (colleague['photo'] != null &&
                                  colleague['photo'] != "")
                              ? Image.network(
                                      "$urlStarter/" + colleague['photo']!)
                                  .image
                              : defultprofileImage,
                        ),
                        title: Text('$firstname $lastname'),
                        subtitle: Text('$username'),
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
