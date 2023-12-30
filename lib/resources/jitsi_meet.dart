/*import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class JitsiMeetMethods {
  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    required String username,
    required String email,
    required String subject,
  }) async {
    try {
      print(roomName);
      var options = JitsiMeetConferenceOptions(
        //serverURL: "https://meet.jit.si",
        room: roomName,
        configOverrides: {
          "startWithAudioMuted": isAudioMuted,
          "startWithVideoMuted": isVideoMuted,
          "subject": subject,
        },
        featureFlags: {"unsaferoomwarning.enabled": false},
        userInfo: JitsiMeetUserInfo(
            displayName: username, email: email),
      );
      var jitsiMeet = JitsiMeet();
      await jitsiMeet.join(options);
    } catch (error) {
      print("error: $error");
    }
  }
}
*/