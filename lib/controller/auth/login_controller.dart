import 'dart:convert';
import 'package:featurehub_sse_client/featurehub_sse_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:universal_io/io.dart' as io;
import 'package:growify/Platform.dart'; // our enum
import 'package:growify/multiplatform.dart';
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
  connectToSSE(String username) async {
    Platform platform = getPlatform(); // calling as top-level declaration
    var accessToken = GetStorage().read("accessToken") ?? "";
    var url = urlSSEStarter + '/userNotifications/events';
  print(platform.name);
  if(platform.name== 'web'){
    
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
    );
  }else{
      EventSource eventSource = await EventSource.connect(
      url,
      headers: {
        'Authorization': 'bearer ' + accessToken,
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      },
    );
    eventSource.listen((Event event) {
      print("New event:");
      print("  event: ${event.event}");
      print("  data: ${event.data}");
    });
    }
    /*var accessToken = GetStorage().read("accessToken") ?? "";
    var url = urlSSEStarter + '/userNotifications/events';
    
    if(kIsWeb){
      final client = io.HttpClient();
      EventSource eventSource = await EventSource.connect(
      url,
      headers: {
        'Authorization': 'bearer ' + accessToken,
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      },
      client: client
    );
    eventSource.listen((Event event) {
      print("New event:");
      print("  event: ${event.event}");
      print("  data: ${event.data}");
    });
    }
    else{
      EventSource eventSource = await EventSource.connect(
      url,
      headers: {
        'Authorization': 'bearer ' + accessToken,
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      },
    );
    eventSource.listen((Event event) {
      print("New event:");
      print("  event: ${event.event}");
      print("  data: ${event.data}");
    });*/
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