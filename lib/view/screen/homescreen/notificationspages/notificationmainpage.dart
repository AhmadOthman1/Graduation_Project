import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/controller/home/notification/notification_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/main.dart';
import 'package:growify/view/screen/homescreen/chat/chatpagemessages.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

final ScrollController scrollController = ScrollController();

class _NotificationsPageState extends State<NotificationsPage> {
  late NotificationsController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  final AssetImage defultNotificationImage =
      const AssetImage("images/notification.jpg");
  final SearchControllerImp searchController = Get.put(SearchControllerImp());

  @override
  void initState() {
    super.initState();
    _controller = NotificationsController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadNotifications(_controller.page);
      setState(() {
        _controller.page++;
        _controller.notifications;
      });
      print('Data loaded: ${_controller.notifications.length} notifications');
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // reached the bottom, load more notifications
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
              itemCount: _controller.notifications.length,
              itemBuilder: (context, index) {
                final notice = _controller.notifications[index];

                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: (notice['notificationType'] != "post" && notice['notificationType'] != "job" )
                            ? (notice['photo'] != null && notice['photo'] != "")
                                ? Image.network(
                                        "$urlStarter/" + notice['photo']!)
                                    .image
                                : defultprofileImage
                            : defultNotificationImage,
                      ),
                      title: Text(notice['notificationType'] != "post" &&notice['notificationType'] != "job" 
                          ? "${notice['notificationPointer']} ${notice['notificationContent']}"
                          : "${notice['notificationContent']}"),
                      subtitle: Text(notice['date']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: () async {
                              if (notice['notificationType'] == "connection") {
                                searchController.goToUserPage(
                                    notice['notificationPointer']!);
                              } else if (notice['notificationType'] == "call" ||
                                  notice['notificationType'] == "message") {
                                HomePageControllerImp controller =
                                    Get.put(HomePageControllerImp());
                                var foundUser =
                                    await controller.userChatProfileInfo(
                                        notice['notificationPointer']);

                                if (foundUser != null) {
                                  MyApp.navigatorKey.currentState?.push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ChatPageMessages(data: foundUser),
                                    ),
                                  );
                                }
                              } else if (notice['notificationType'] == "post") {
                                _controller.showPost(notice['notificationPointer']);
                              }else if (notice['notificationType'] == "job") {
                                await _controller.showJob(notice['notificationPointer']);
                              }
                            },
                          ),
                        ],
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
