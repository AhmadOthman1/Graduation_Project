import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/services/secrets.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

Future<bool> userLeaved(groupId,meetingID) async {
  print(groupId);
  print(meetingID);
  print(";;;;;;;;;;;;;;;;;;;;;;;;;");
  var url = "$urlStarter/user/leaveGroupMeeting";
    Map<String, dynamic> jsonData = {
      "meetingId": meetingID,
      "groupId": groupId,
    };
    String jsonString = jsonEncode(jsonData);
    var response = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      return userLeaved(groupId,meetingID) ;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }else {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return true;
    }
  return true;
}

class VideoConferencePage extends StatelessWidget {
  final String meetingID;
  final String userId;
  final String userName;
  final String groupId;
  final socket;
  const VideoConferencePage({
    Key? key,
    required this.meetingID,
    required this.userId,
    required this.userName,
    required this.groupId,
    required this.socket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: Secrets.appID,
        appSign: Secrets.appSign,
        userID: userId,
        userName: userName,
        conferenceID: meetingID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          onLeaveConfirmation: (BuildContext context) async {
            return await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white!.withOpacity(0.7),
                  title: const Text("are you sure you want to leave",
                      style: TextStyle(color: Colors.black)),
                  content: const Text(
                      "You can rejoin the meeting any time unless its ended",
                      style: TextStyle(color: Colors.black)),
                  actions: [
                    ElevatedButton(
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.black)),
                      onPressed: () => {Navigator.of(context).pop(false)},
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red[900], // Set the background color
                        ),
                        child: const Text("leave",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          await userLeaved(groupId, meetingID);
                          Navigator.of(context).pop(true);
                        }),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
