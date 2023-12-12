import 'dart:convert';
import 'package:featurehub_sse_client/featurehub_sse_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/services/notification_service.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:growify/Platform.dart'; // our enum
import 'package:growify/multiplatform.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

abstract class LoginController extends GetxController {
  login(email, password);
  goToSignup();
  goToForgetPassword();
  postLogin(email, password);
}

class LoginControllerImp extends LoginController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController email;
  late TextEditingController password;

  bool isshowpass = true;

  showPassord() {
    isshowpass = isshowpass == true ? false : true;
    update();
  }

  LoginControllerImp() {
    // Initialize formstate in the constructor.
    formstate = GlobalKey<FormState>();
  }
  @override
  Future postLogin(email, password) async {
    var url = "$urlStarter/user/Login";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "email": email.trim(),
          "password": password.trim(),
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    return responce;
  }

  @override
  login(email, password) async {
    // Check if formstate.currentState is not null before using it.
    try {
      var res = await postLogin(email, password);
      var resbody = jsonDecode(res.body);
      if (res.statusCode == 409) {
        return resbody['message'];
      } else if (res.statusCode == 200) {
        resbody['message'] = "";
        GetStorage().write("accessToken", resbody['accessToken']);
        GetStorage().write("refreshToken", resbody['refreshToken']);
        GetStorage().write("loginemail", email);
        GetStorage().write("username", resbody['username']);
        await connectToSSE(resbody['username']);

        Get.offNamed(AppRoute.homescreen);
      }
    } catch (err) {
      print(err);
      return "server error";
    }
  }

  @override
  goToSignup() {
    Get.offNamed(AppRoute.signup);
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  goToForgetPassword() {
    Get.offNamed(AppRoute.forgetpassword);
  }

  /*void connectToSSE(String username) {
    var accessToken = GetStorage().read("accessToken") ?? "";
    SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: urlSSEStarter+'/userNotifications/notifications',
      header: {
        'Authorization': 'bearer ' + accessToken,
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      },
    ).listen((event) {
      print('Id: ' + event.id!);
      print('Event: ' + event.event!);
      print('Data: ' + event.data!);
    });
  }*/
  Future<void> connectToSSE(String username) async {
    Platform platform = getPlatform();
    var accessToken = GetStorage().read("accessToken") ?? "";
    var url = urlSSEStarter + '/userNotifications/notifications';
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
                body: "${notificationPointer} has ${notificationContent}",
                summary: "${createdAt}",
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
  /*
    Map<String, dynamic> headers = {
      'Authorization': 'bearer ' + accessToken,
      "Accept": "text/event-stream",
      "Cache-Control": "no-cache",
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
    );*/
/*
    await SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: urlSSEStarter + '/userNotifications/events',
      header: {
        'Authorization': 'bearer ' + accessToken,
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      },
    ).listen((event) {
      print("innnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnweb");
      String eventData = event.data ?? '';
      print('data: ' + eventData);

      // Print to browser console
    });
  }*/
}
/*
Stream<String> connect(
  String url,
  String type,
  Map<String, dynamic>? headers,
) {
  int progress = 0;
  final httpRequest = HttpRequest();
  final streamController = StreamController<String>();
  httpRequest.open(type, url);
  headers?.forEach((key, value) {
    httpRequest.setRequestHeader(key, value.toString());
  });
  httpRequest.addEventListener('progress', (event) {
    final data = httpRequest.responseText!.substring(progress);
    progress += data.length;
    streamController.add(data);
  });
  httpRequest.addEventListener('loadend', (event) {
    httpRequest.abort();
    streamController.close();
  });
  httpRequest.addEventListener('error', (event) {
    streamController.addError(
      httpRequest.responseText ?? httpRequest.status ?? 'err',
    );
  });
  httpRequest.send();
  return streamController.stream;
}
*/
