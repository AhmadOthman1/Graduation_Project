import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
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
import 'package:http/http.dart' as http;

abstract class HomeScreeenController extends GetxController {
  changePage(int currentpage);
}

class HomeScreenControllerImp extends HomeScreeenController {
  int currentpage = 0;
  late EventSource eventSource;
  LogOutButtonControllerImp _logoutController =
      Get.put(LogOutButtonControllerImp());

  List<Widget> listPage = [
    const Homepage(),
    const NotificationsPage(),
    JobsPage(),
    NetworksPage()
  ];

  List titlebottomappbar = [
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
    currentpage = indexofpage;
    update();
  }

  var receivedCallAudio;

  Future<void> connectToSSE(String username) async {
    try {
      Platform platform = getPlatform();
      var accessToken = GetStorage().read("accessToken") ?? "";
      var url = '$urlSSEStarter/userNotifications/notifications';
      var authUrl = '$urlSSEStarter/userNotifications/notificationsAuth';
      var responce = await http.get(Uri.parse(authUrl), headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + (GetStorage().read('accessToken') ?? ""),
      });
      if (responce.statusCode == 403) {
        await getRefreshToken(GetStorage().read('refreshToken'));
        connectToSSE(username);
        return;
      } else if (responce.statusCode == 401) {
        _logoutController.goTosigninpage();
        return;
      } else if (responce.statusCode == 200) {
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
          eventSource = await EventSource.connect(url,
              headers: {
                'Authorization': 'bearer ' + accessToken,
                "Accept": "text/event-stream",
                "Cache-Control": "no-cache",
                "username": username,
              },
              openOnlyOnFirstListener: true,
              closeOnLastListener: true);

          eventSource.listen((Event event) async {
            if (GetStorage().read("username") == null) {
              eventSource.lastStreamDisconnected();
            } else {
              var data = event.data;
              if (data != null && data != [] && data != "") {
                Map<String, dynamic> jsonData = json.decode(data);
                //to solve duplicated notification problem
                var lastNotificationId =
                    GetStorage().read("lastNotificationId");
                if (lastNotificationId == null ||
                    jsonData['id'] != lastNotificationId) {
                  GetStorage().write("lastNotificationId", jsonData['id']);
                  // Access individual properties
                  String username = jsonData['username'];
                  String notificationType = jsonData['notificationType'];
                  String notificationContent = jsonData['notificationContent'];
                  String notificationPointer = jsonData['notificationPointer'];
                  String createdAt = jsonData['createdat'];
                  var playSound = true;
                  Duration timeoutAfter = Duration(seconds: 5);
                  if (notificationType == "call") {
                    playSound = false;
                    timeoutAfter = Duration(seconds: 25);
                    playCallingSound();
                  }
                  await NotificationService.initializeNotification(playSound);
                  await NotificationService.showNotification(
                      title: "Growify",
                      body: "$notificationPointer $notificationContent",
                      summary: createdAt,
                      payload: {
                        "navigate": "true",
                        "call": notificationType == "call" ? "true" : "false",
                      },
                      chronometer: Duration.zero,
                      timeoutAfter: timeoutAfter,
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
            }
          });
        }
      }
    } catch (err) {}
  }

  void playCallingSound() {
    receivedCallAudio = AssetsAudioPlayer();
    if (kIsWeb) {
      receivedCallAudio.open(Audio.network("audio/receivedCall25.mp3"));
    } else {
      receivedCallAudio.open(Audio("audio/receivedCall25.mp3"));
    }
    receivedCallAudio.play();
  }

  stopCallingSound() {
    receivedCallAudio.pause();
    //receivedCallAudio = AssetsAudioPlayer();
  }
}
