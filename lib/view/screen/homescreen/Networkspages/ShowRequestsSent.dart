import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/network_controller/ShowRequestsSent_controller.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/global.dart';

class ShowRequestsSent extends StatefulWidget {
  const ShowRequestsSent({Key? key}) : super(key: key);

  @override
  _ShowRequestsSentState createState() => _ShowRequestsSentState();
}

final ScrollController scrollController = ScrollController();

class _ShowRequestsSentState extends State<ShowRequestsSent> {
  final NetworkMainPageControllerImp Networkcontroller =
      Get.put(NetworkMainPageControllerImp());
  late ShowRequestsSentController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");

  @override
  void initState() {
    super.initState();
    _controller = ShowRequestsSentController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadRequestsSent(_controller.page);
      setState(() {
        _controller.page++;
        _controller.requestsSent;
      });
      print('Data loaded: ${_controller.requestsSent.length} notifications');
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
          title: const Text('Requests Sent'),
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
                        itemCount: _controller.requestsSent.length,
                        itemBuilder: (context, index) {
                          final sent = _controller.requestsSent[index];
                          final firstname = sent['firstname'];
                          final lastname = sent['lastname'];
                          final username = sent['username'];

                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  final userUsername = username;
                                  Networkcontroller.goToUserPage(userUsername!);
                                },
                                leading: CircleAvatar(
                                  backgroundImage: (sent['photo'] != null &&
                                          sent['photo'] != "")
                                      ? Image.network(
                                              "$urlStarter/" + sent['photo']!)
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
          title: const Text('Requests Sent'),
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
                itemCount: _controller.requestsSent.length,
                itemBuilder: (context, index) {
                  final sent = _controller.requestsSent[index];
                  final firstname = sent['firstname'];
                  final lastname = sent['lastname'];
                  final username = sent['username'];

                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          final userUsername = username;
                          Networkcontroller.goToUserPage(userUsername!);
                        },
                        leading: CircleAvatar(
                          backgroundImage: (sent['photo'] != null &&
                                  sent['photo'] != "")
                              ? Image.network("$urlStarter/" + sent['photo']!)
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
