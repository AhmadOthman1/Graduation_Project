import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/homepages/homemainPage.dart';
import 'package:growify/view/screen/homescreen/Networkspages/networkmainpage.dart';
import 'package:growify/view/screen/homescreen/JobsPages/jobsmainpage.dart';
import 'package:growify/view/screen/homescreen/notificationspages/notificationmainpage.dart';
import 'dart:convert';
import 'package:featurehub_sse_client/featurehub_sse_client.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/global.dart';
import 'package:growify/services/notification_service.dart';
import 'dart:async';
import 'package:growify/Platform.dart'; // our enum
import 'package:growify/multiplatform.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

abstract class HomeScreeenController extends GetxController{

changePage(int currentpage);

}

class HomeScreenControllerImp extends HomeScreeenController{

  int currentpage=0;

  List<Widget>listPage=[

     const Homepage(),
     const NotificationsPage(),
   JobsPage(),

    NetworksPage()

  ];

  List titlebottomappbar=[
    "Home",
    "Notices",
    "Jobs",
    "Networks",
    
    
  ];

  List<IconData> icons = [
    Icons.home,
    Icons.notifications,
    Icons.work,
    Icons.diversity_3,
    
    
  ];
  @override
  changePage(int indexofpage) {


    currentpage=indexofpage;
    update();
  
  }
  Future<void> connectToSSE(String username) async {
    Platform platform = getPlatform();
    var accessToken = GetStorage().read("accessToken") ?? "";
    var url = '$urlSSEStarter/userNotifications/notifications';
    print(platform.name);
    if (platform.name == 'web') {
      Map<String, dynamic> headers = {
        'Authorization': 'bearer ' + accessToken,
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
        "username": username,
      };
      final responseStream = connect(url, 'GET', headers);
      responseStream.listen(
        (data) {
          print('Received data: $data');
          // Handle the received data
        },
        onDone: () {
          print('Request completed');
        },
        onError: (error) {
          print('Error: $error');
          // Handle the error
        },
      );
    } else {
      EventSource eventSource = await EventSource.connect(
        url,
        headers: {
          'Authorization': 'bearer ' + accessToken,
          "Accept": "text/event-stream",
          "Cache-Control": "no-cache",
          "username": username,
        },
      );
      eventSource.listen((Event event) async {
        var data = event.data;
        if (data != null && data != [] && data != "") {
          Map<String, dynamic> jsonData = json.decode(data);
          //to solve duplicated notification problem
          var lastNotificationId = GetStorage().read("lastNotificationId");
          if (lastNotificationId == null ||
              jsonData['id'] != lastNotificationId) {
            GetStorage().write("lastNotificationId", jsonData['id']);
            // Access individual properties
            String username = jsonData['username'];
            String notificationType = jsonData['notificationType'];
            String notificationContent = jsonData['notificationContent'];
            String notificationPointer = jsonData['notificationPointer'];
            String createdAt = jsonData['createdat'];
            await NotificationService.showNotification(
                title: "Growify",
                body: "$notificationPointer has $notificationContent",
                summary: createdAt,
                payload: {
                  "navigate": "true",
                },
                actionButtons: [
                  NotificationActionButton(
                    key: 'check',
                    label: 'Check it out',
                    actionType: ActionType.SilentAction,
                    color: Colors.green,
                  )
                ]);
          }

          print("New event:");
          print("  data: ${event.data}");
        }
      });
    }
  }

}