import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/chat/screen_select_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:socket_io_client/socket_io_client.dart';

LogOutButtonControllerImp _logoutController = LogOutButtonControllerImp();

Future<bool> userLeaved(groupId, meetingID) async {
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
    return userLeaved(groupId, meetingID);
  } else if (response.statusCode == 401) {
    _logoutController.goTosigninpage();
  } else {
    var responseBody = jsonDecode(response.body);
    print(responseBody['message']);
    return true;
  }
  return true;
}

class meetingPage extends StatefulWidget {
  final String meetingID;
  final String userId;
  final String userName;
  final photo;
  final String groupId;
  final socket;
  final dynamic offer;
  const meetingPage({
    Key? key,
    required this.meetingID,
    required this.userId,
    required this.userName,
    required this.photo,
    required this.groupId,
    required this.socket,
    this.offer,
  }) : super(key: key);
  @override
  State<meetingPage> createState() => _MeetingPageState();
}

Map<String, dynamic> configuration = {
  'iceServers': [
    {'urls': 'stun:freeturn.net:5349'},
    {
      'urls': 'turns:freeturn.tel:5349',
      'username': 'free',
      'credential': 'free'
    },
  ],
  'optional': [
    {'DtlsSrtpKeyAgreement': true},
    {'RtpDataChannels': true}
  ],
  'sdpSemantics': "unified-plan",
};
final Map<String, dynamic> _constraints = {
  'mandatory': {
    'OfferToReceiveVideo': true,
    'OfferToReceiveAudio': true,
  },
  'optional': [],
};

class _MeetingPageState extends State<meetingPage> {
  DesktopCapturerSource? selected_source_;
  List<RTCRtpSender> _senders = <RTCRtpSender>[];
  Function(MediaStream stream)? onLocalStream;
  // videoRenderer for localPeer
  List<Map<String, dynamic>> socketIdRemotes = [];
  // mediaStream for localPeer
  bool isScreenSharing = false;
  bool isScreenRecording = false;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _screenStream;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  bool _isSend = false;

  // media status
  bool isAudioOn = true, isVideoOn = true, isFrontCameraSelected = true;
  void initState() {
    // setup Peer Connection
    initRenderers();
    _createPeerConnection().then(
      (pc) async {
        _peerConnection = pc; // set the new peer connection to _peerConnection
        _localStream = await _getUserMedia(); // store local stream
        setState(() {});
        _localStream!.getTracks().forEach((track) {
          // add the stream tracks (video/audio) to the connection with the server
          _peerConnection!.addTrack(track, _localStream!);
          setState(() {});
        });
      },
    );
    connectAndListen();
    super.initState();
  }

// Initialize video renderer
  initRenderers() async {
    await _localRenderer.initialize();
  }

  _getUserMedia() async {
    MediaStream stream = await navigator.mediaDevices.getUserMedia({
      'audio': isAudioOn,
      'video': isVideoOn
          ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
          : false,
    });

    setState(() {
      _localRenderer.srcObject =
          stream; // to show the local stream on the screen
    });

    return stream;
  }

  _createPeerConnection() async {
    RTCPeerConnection pc = await createPeerConnection(configuration);

    pc.onRenegotiationNeeded = () async {
      if (!_isSend) {
        _isSend = true;
        await _createOffer();
      }
    };
    return pc;
  }

//create sdp offer to connect to server
  _createOffer() async {
    RTCSessionDescription description = await _peerConnection!.createOffer({
      'mandatory': {
        'OfferToReceiveVideo': true,
        'OfferToReceiveAudio': true,
      },
      'optional': [],
    });
    ;
    await _peerConnection!.setLocalDescription(description);
    var session = parse(description.sdp.toString());
    String sdp = write(session, null);
    setState(() {});
    await widget.socket!.emit('joinMeeting', {
      'sdp': sdp,
      'meetingID': widget.meetingID
    }); //send the sdp to the server
  }

  // Connect to the server and set up event listeners
  void connectAndListen() async {
    await widget.socket!.on('peerLeaved', (data) async {
      String peer = data['socketId']; //get peer socket
      print(peer);
      int index =
          socketIdRemotes.indexWhere((item) => item['socketId'] == peer);
      if (index != -1) {
        if (socketIdRemotes[index]['stream'] != null) {
          try {
            socketIdRemotes[index]['stream'].srcObject = null;

            await socketIdRemotes[index]['stream'].dispose();
            socketIdRemotes[index]['stream'] = null;
            setState(() {});
          } catch (err) {
            print(err);
          }
        }
        if (socketIdRemotes[index]['pc'] != null) {
          try {
            await socketIdRemotes[index]['pc'].close();
            await socketIdRemotes[index]['pc'].dispose();
            socketIdRemotes[index]['pc'] = null;
            setState(() {});
          } catch (err) {
            print(err);
          }
        }
        socketIdRemotes.removeAt(index);
      }
      setState(() {});
    });
    //when new peer connected to the server
    widget.socket!.on('newPeerJoined', (data) async {
      String newUser = data['socketId']; //get peer socket
      //create peer RTCVideoRenderer to show his stream
      RTCVideoRenderer stream = await new RTCVideoRenderer();
      await stream.initialize();
      //save his stream in the array
      setState(() {});
      var peerUser = {
        'socketId': newUser,
        'pc': null,
        'stream': stream,
      };
      socketIdRemotes.add(peerUser);

      setState(() {});
      int index =
          socketIdRemotes.indexWhere((item) => item['socketId'] == newUser);
      await _createPeerConnectionAnswer(newUser).then((pcRemote) async {
        await pcRemote.addTransceiver(
          kind: RTCRtpMediaType
              .RTCRtpMediaTypeVideo, //  the transceiver will be used for handling video media.
          init: RTCRtpTransceiverInit(
            //receive only from the peer
            direction: TransceiverDirection.RecvOnly,
          ),
        );
        peerUser['pc'] = pcRemote;
        setState(() {});
      });
    });
    // When this user has joined the meeting
    widget.socket!.on('joined', (data) async {
      //tack the users in the meeting sockets
      List<String> listSocketId =
          (data['sockets'] as List<dynamic>).map((e) => e.toString()).toList();
      setState(() {});
      print("==================================================");
      print(listSocketId);
      print("==================================================");
      for (int index = 0; index < listSocketId.length; index++) {
        String user = listSocketId[index];
        //set a stream for each user to get there stream
        RTCVideoRenderer stream = await new RTCVideoRenderer();
        await stream.initialize();
        setState(() {});
        //store there streams
        var peerUser = {
          'socketId': user,
          'pc': null,
          'stream': stream,
        };
        socketIdRemotes.add(peerUser);

        setState(() {});

        // Create a peer connection answer for the users
        _createPeerConnectionAnswer(user).then((pcRemote) async {
          await pcRemote.addTransceiver(
            kind: RTCRtpMediaType
                .RTCRtpMediaTypeVideo, //  the transceiver will be used for handling video media.
            init: RTCRtpTransceiverInit(
              //receive only from the peer
              direction: TransceiverDirection.RecvOnly,
            ),
          );
          peerUser['pc'] = pcRemote;
        });
        setState(() {});
      }

      await _setRemoteDescription(data['sdp']);
      setState(() {});
    });
    // When receiving the Set Session Configuration from the server
    // listen from the new peer
    await widget.socket!.on('RECEIVE-SSC', (data) async {
      print(data['socketId']);
      int index = socketIdRemotes.indexWhere(
        (element) => element['socketId'] == data['socketId'],
      );
      setState(() {});
      print(index);
      print(socketIdRemotes);
      print(
          "[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]");
      if (index != -1) {
        await _setRemoteDescriptionForReceive(index, data['sdp']);
      }
      setState(() {});
    });
  }

// Create an RTCPeerConnection to answer a peer's connection request
  _createPeerConnectionAnswer(socketId) async {
    RTCPeerConnection pc = await createPeerConnection(configuration);

    // When a new track is received from the peer, set it to the corresponding stream
    pc.onTrack = (track) {
      int index =
          socketIdRemotes.indexWhere((item) => item['socketId'] == socketId);
      socketIdRemotes[index]['stream'].srcObject = track.streams[0];
      setState(() {
        socketIdRemotes[index]['stream'].srcObject = track.streams[0];
      });
      // Call the callback to handle the arrival of the remote stream
      handleRemoteStreamAdded(socketIdRemotes[index]['stream'].srcObject, socketId);
    };
    setState(() {});
    // When renegotiation is needed, create an offer for receiving, modifying an existing connection between two peers
    pc.onRenegotiationNeeded = () async {
      await _createOfferForReceive(socketId);
    };
    return pc;
  }

  handleRemoteStreamAdded(MediaStream stream, String socketId) {
    // Handle the arrival of the remote stream
    print('Remote stream added for $socketId');

    // Check if the stream contains any tracks
    if (stream.getTracks().isNotEmpty) {
      print('Stream has arrived');
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      setState(() {
        
      });
    } else {
      print('Stream has not arrived');
      print('Stream visibility: ${stream.active}');
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      setState(() {
        
      });
      // Trigger rejoin or stream refreshing if needed
    }

    // Update your UI or take necessary actions
  }

  _createOfferForReceive(String socketId) async {
    //get the peer socket
    int index =
        socketIdRemotes.indexWhere((item) => item['socketId'] == socketId);
    if (index != -1) {
      //if socket exists
      // Create an RTCSessionDescription (SDP) offer
      RTCSessionDescription description =
          await socketIdRemotes[index]['pc'].createOffer({
        'mandatory': {
          'OfferToReceiveVideo': true,
          'OfferToReceiveAudio': true,
        },
        'optional': [],
      });
      setState(() {});
      // Set the local description of the current peer's RTCPeerConnection
      await socketIdRemotes[index]['pc'].setLocalDescription(description);

      setState(() {});
      // Transform the session description to SDP format
      var session = parse(description.sdp.toString());
      setState(() {});
      String sdp = write(session, null);
      // Emit an event to the server to send the offer to the specified peer how need renegotiation
      //that send the user Session to all receivers (other peers) to Listen to
      setState(() {});
      await widget.socket!.emit('RECEIVE-CSS', {
        'sdp': sdp,
        'socketId': socketId,
      });
    }
  }

  // Set the remote description of the main RTCPeerConnection from server
  _setRemoteDescription(sdp) async {
    RTCSessionDescription description =
        new RTCSessionDescription(sdp, 'answer');
    setState(() {});
    await _peerConnection!.setRemoteDescription(description);
    setState(() {});
  }

  // Set the remote description of a specific RTCPeerConnection for receiving
  _setRemoteDescriptionForReceive(indexSocket, sdp) async {
    RTCSessionDescription description =
        new RTCSessionDescription(sdp, 'answer');
    setState(() {});
    await socketIdRemotes[indexSocket]['pc'].setRemoteDescription(description);
    setState(() {});
  }

  _leaveCall() async {
    if (mounted) {
      widget.socket!.off("newPeerJoined");
      widget.socket!.off("peerLeaved");
      widget.socket!.off("joined");
      widget.socket!.off("RECEIVE-SSC");

      if (mounted) {
        setState(() {});
      }
      Navigator.pop(context);
      int count = 0;
      //Navigator.of(context).popUntil((_) => count++ >= 2);
    }
  }

  _toggleMic() {
    // change status
    isAudioOn = !isAudioOn;
    // enable or disable audio track
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });
    setState(() {});
  }

  _toggleCamera() {
    // change status

    isVideoOn = !isVideoOn;

    // enable or disable video track
    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
    setState(() {});
  }

  _switchCamera() {
    // change status
    isFrontCameraSelected = !isFrontCameraSelected;

    // switch camera
    _localStream?.getVideoTracks().forEach((track) {
      // ignore: deprecated_member_use
      track.switchCamera();
    });
    setState(() {});
  }

  startScreenRecord(bool audio) async {
    bool start = false;

    if (audio) {
      start = await FlutterScreenRecording.startRecordScreenAndAudio("call");
    } else {
      start = await FlutterScreenRecording.startRecordScreen("call");
    }

    if (start) {
      setState(() => isScreenRecording = !isScreenRecording);
    }

    return start;
  }

  stopScreenRecord() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    setState(() {
      isScreenRecording = !isScreenRecording;
    });
    print("Opening video");
    print(path);
  }

  @override
  void dispose() {
    widget.socket!.emit("leaveGroupMeeting", {'meetingID': widget.meetingID});
    if (_localRenderer != null) {
      _localRenderer.srcObject = null;
      _localRenderer.dispose();
    }
    socketIdRemotes.forEach((element) {
      if (element['stream'] != null) {
        element['stream'].srcObject = null;
        element['stream'].dispose();
      }
    });
    socketIdRemotes.forEach((element) {
      if (element['pc'] != null) {
        element['pc'].close();
        element['pc'].dispose();
      }
    });
    socketIdRemotes.clear();
    if (_peerConnection != null) {
      _peerConnection?.close();
      _peerConnection?.dispose();
    }
    if (_localStream != null) {
      for (var track in _localStream!.getTracks()) {
        track.stop();
      }
      _localStream?.dispose();
    }
    if (_screenStream != null) {
      for (var track in _screenStream!.getTracks()) {
        track.stop();
      }
      _screenStream?.dispose();
    }
    widget.socket!.off("peerLeaved");

    widget.socket!.off("newPeerJoined");
    widget.socket!.off("joined");
    widget.socket!.off("RECEIVE-SSC");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 15, 15, 15),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(children: [
                /*Container(
                  color: Colors.black,
                  width: size.width,
                  height: size.height,
                  child: socketIdRemotes.isEmpty
                      ? Container(
                          color: Colors.blue,
                        )
                      : RemoteViewCard(
                          remoteRenderer: socketIdRemotes[0]['stream'],
                        ),
                ),*/
                Positioned(
                  bottom: 20.0,
                  left: 12.0,
                  right: 0,
                  child: Container(
                    color: Colors.transparent,
                    height: 150,
                    child: socketIdRemotes.isEmpty
                        ? Container(
                            color: Colors.red,
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: socketIdRemotes.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 6.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color: Colors.blueAccent,
                                    width: 2.0,
                                  ),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Container(
                                    height: 150,
                                    width: 120,
                                    child: RTCVideoView(
                                      socketIdRemotes[index]['stream'],
                                      objectFit: RTCVideoViewObjectFit
                                          .RTCVideoViewObjectFitContain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                Positioned(
                  top: 45.0,
                  left: 15.0,
                  child: Column(
                    children: [
                      _localRenderer.textureId == null
                          ? Container(
                              height: 150,
                              width: 220,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                border: Border.all(
                                    color: Colors.blueAccent, width: 2.0),
                              ),
                            )
                          : FittedBox(
                              fit: BoxFit.cover,
                              child: Container(
                                height: 150,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0)),
                                  border: Border.all(
                                      color: Colors.blueAccent, width: 2.0),
                                ),
                                child: RTCVideoView(
                                  _localRenderer,
                                  objectFit: RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitContain,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Container(
                color: Color.fromARGB(
                    255, 232, 230, 230), // Set the background color for Padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(isAudioOn ? Icons.mic : Icons.mic_off),
                      onPressed: _toggleMic,
                    ),
                    IconButton(
                      icon: const Icon(Icons.call_end),
                      iconSize: 30,
                      onPressed: _leaveCall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.cameraswitch),
                      onPressed: _switchCamera,
                    ),
                    IconButton(
                      icon:
                          Icon(isVideoOn ? Icons.videocam : Icons.videocam_off),
                      onPressed: _toggleCamera,
                    ),
                    /*IconButton(
                      onPressed: () async {
                        print(isScreenSharing);
                        if (!isScreenSharing) {
                          await selectScreenSourceDialog(context);
                        } else {
                          await _stop();
                        }
                      },
                      icon: Icon(isScreenSharing ? Icons.tv : Icons.tv_off),
                    ),
                    IconButton(
                      onPressed: () async {
                        print(isScreenRecording);
                        if (!isScreenRecording) {
                          setState(() {
                            isScreenRecording = !isScreenRecording;
                          });
                          startScreenRecord(true);
                        } else {
                          setState(() {
                            isScreenRecording = !isScreenRecording;
                          });
                          stopScreenRecord();
                        }
                      },
                      icon: Icon(isScreenRecording
                          ? Icons.fiber_manual_record
                          : Icons.fiber_smart_record_outlined),
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
