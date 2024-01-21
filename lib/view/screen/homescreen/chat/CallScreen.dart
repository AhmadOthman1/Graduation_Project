import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/chat/screen_select_dialog.dart';

class CallScreen extends StatefulWidget {
  final String callerId, calleeId;
  final photo;
  final dynamic offer;
  final socket;
  final Function onCallEnded;
  final bool? isVideo;
  final String? type;
  const CallScreen({
    super.key,
    this.offer,
    this.photo,
    required this.callerId,
    required this.calleeId,
    required this.socket,
    this.isVideo,
    this.type,
    required this.onCallEnded,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  DesktopCapturerSource? selected_source_;
  List<RTCRtpSender> _senders = <RTCRtpSender>[];
  bool isCallAccepted = false;
  Function(MediaStream stream)? onLocalStream;
  // videoRenderer for localPeer
  final _localRTCVideoRenderer = RTCVideoRenderer();

  // videoRenderer for remotePeer
  final _remoteRTCVideoRenderer = RTCVideoRenderer();

  // mediaStream for localPeer
  bool isScreenSharing = false;
  MediaStream? _localStream;
  MediaStream? _screenStream;
  MediaStream? _prevStream;
  // RTC peer connection
  RTCPeerConnection? _rtcPeerConnection;

  // list of rtcCandidates to be sent over signalling
  List<RTCIceCandidate> rtcIceCadidates = [];

  // media status
  bool isAudioOn = true, isVideoOn = true, isFrontCameraSelected = true;
  // call ends with no response
  late Timer callTimeout;
  @override
  void initState() {
    // initializing renderers
    _localRTCVideoRenderer.initialize();
    _remoteRTCVideoRenderer.initialize();
    startCallTimeout();

    // setup Peer Connection
    _setupPeerConnection();
    super.initState();
  }

/*
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
*/
  void startCallTimeout() {
    // Set a timer for 25 seconds
    callTimeout = Timer(Duration(seconds: 25), () {
      if (!isCallAccepted) {
        _leaveCall();
      }
    });
  }

  void cancelCallTimeout() {
    // Cancel the call timeout if it's still active
    if (callTimeout.isActive) {
      callTimeout.cancel();
    }
  }

  _setupPeerConnection() async {
    // create peer connection
    _rtcPeerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:freeturn.net:5349'},
        {
          'urls': 'turns:freeturn.tel:5349',
          'username': 'free',
          'credential': 'free'
        },
      ]
    }, {
      'optional': [
        {'DtlsSrtpKeyAgreement': true},
        {'RtpDataChannels': true}
      ]
    });
    final Map<String, dynamic> _constraints = {
      'mandatory': {
        'OfferToReceiveVideo': true,
        'OfferToReceiveAudio': true,
      },
      'optional': [],
    };

    // listen for remotePeer mediaTrack event
    _rtcPeerConnection!.onTrack = (event) {
      _remoteRTCVideoRenderer.srcObject = event.streams[0];
      setState(() {
        _remoteRTCVideoRenderer.srcObject = event.streams[0];
      });
    };
    isVideoOn =
        widget.isVideo != null && widget.isVideo == false ? false : true;
    // get localStream
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': isAudioOn,
      'video': isVideoOn
          ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
          : false,
    });

    // add mediaTrack to peerConnection
    _localStream!.getTracks().forEach((track) async {
      _senders.add(await _rtcPeerConnection!.addTrack(track, _localStream!));
    });

    // set source for local video renderer
    _localRTCVideoRenderer.srcObject = _localStream;

    widget.socket!.on("callEnded", (data) async {
      incomingSDPOffer = null;
      if (mounted) {
        setState(() {
          widget.onCallEnded();
        });
      }

      Navigator.pop(context);
    });
    setState(() {});
    // for Incoming call
    if (widget.offer != null) {
      // listen for Remote IceCandidate
      if (mounted) {
        setState(() {
          isCallAccepted = true;
        });
      }
      widget.socket!.on("IceCandidate", (data) {
        print("/////////////////////////////////////////");
        print(data["iceCandidate"]["candidate"]);
        print("/////////////////////////////////////////");
        String candidate = data["iceCandidate"]["candidate"];
        String sdpMid = data["iceCandidate"]["id"];
        int sdpMLineIndex = data["iceCandidate"]["label"];

        // add iceCandidate
        _rtcPeerConnection!.addCandidate(RTCIceCandidate(
          candidate,
          sdpMid,
          sdpMLineIndex,
        ));
      });

      // set SDP offer as remoteDescription for peerConnection
      await _rtcPeerConnection!.setRemoteDescription(
        RTCSessionDescription(widget.offer["sdp"], widget.offer["type"]),
      );

      // create SDP answer
      RTCSessionDescription answer =
          await _rtcPeerConnection!.createAnswer(_constraints);

      // set SDP answer as localDescription for peerConnection
      _rtcPeerConnection!.setLocalDescription(answer);

      // send SDP answer to remote peer over signalling
      if (widget.type != null && widget.type == "P") {
        widget.socket!.emit("answerPageCall", {
          "calleeId": widget.calleeId,
          "callerId": widget.callerId,
          "sdpAnswer": answer.toMap(),
        });
      } else {
        widget.socket!.emit("answerCall", {
          "calleeId": widget.calleeId,
          "callerId": widget.callerId,
          "sdpAnswer": answer.toMap(),
        });
      }
    }
    // for Outgoing Call
    else {
      // listen for local iceCandidate and add it to the list of IceCandidate
      _rtcPeerConnection!.onIceCandidate =
          (RTCIceCandidate candidate) => rtcIceCadidates.add(candidate);

      // when call is accepted by remote peer
      widget.socket!.on("callAnswered", (data) async {
        // set SDP answer as remoteDescription for peerConnection
        if (mounted) {
          setState(() {
            isCallAccepted = true;
          });
        }

        print("/////////////////////////////////////////");
        print(data);
        print("/////////////////////////////////////////");
        await _rtcPeerConnection!.setRemoteDescription(
          RTCSessionDescription(
            data["sdpAnswer"]["sdp"],
            data["sdpAnswer"]["type"],
          ),
        );

        // send iceCandidate generated to remote peer over signalling
        for (RTCIceCandidate candidate in rtcIceCadidates) {
          print("/////////////////////////////////////////");
          print(candidate);
          print("/////////////////////////////////////////");
          widget.socket!.emit("IceCandidate", {
            "callerId": widget.callerId,
            "calleeId": widget.calleeId,
            "iceCandidate": {
              "id": candidate.sdpMid,
              "label": candidate.sdpMLineIndex,
              "candidate": candidate.candidate
            }
          });
        }
      });

      // create SDP Offer
      RTCSessionDescription offer =
          await _rtcPeerConnection!.createOffer(_constraints);

      // set SDP offer as localDescription for peerConnection
      await _rtcPeerConnection!.setLocalDescription(offer);

      // make a call to remote peer over signalling
      if (widget.type != null && widget.type == "P") {
        widget.socket!.emit('makePageCall', {
        "callerId": widget.callerId,
        "calleeId": widget.calleeId,
        "photo": widget.photo,
        "sdpOffer": offer.toMap(),
        "isVideo": widget.isVideo,
      });
      } else {
        widget.socket!.emit('makeCall', {
        "callerId": widget.callerId,
        "calleeId": widget.calleeId,
        "photo": widget.photo,
        "sdpOffer": offer.toMap(),
        "isVideo": widget.isVideo,
      });
      }
      
    }
  }

  _leaveCall() async {
    if (mounted) {
      if (widget.type != null && widget.type == "P") {
        widget.socket!.emit("leavePageCall", {
        "user1": widget.calleeId,
        "user2": widget.callerId,
      });
      } else {
       widget.socket!.emit("leaveCall", {
        "user1": widget.calleeId,
        "user2": widget.callerId,
      });
      }
      
      widget.socket!.off("callEnded");
      widget.socket!.off("IceCandidate");
      widget.socket!.off("callAnswered");
      incomingSDPOffer = null;

      if (mounted) {
        setState(() {
          widget.onCallEnded();
        });
      }
      cancelCallTimeout();
      Navigator.pop(context);
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

  Future<void> selectScreenSourceDialog(BuildContext context) async {
    try {
      if (WebRTC.platformIsDesktop) {
        print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiind");
        final source = await showDialog<DesktopCapturerSource>(
          context: context,
          builder: (context) => ScreenSelectDialog(),
        );
        if (source != null) {
          await _shareScreen(source);
        }
      } else {
        if (WebRTC.platformIsAndroid) {
          // Android specific
          Future<void> requestBackgroundPermission(
              [bool isRetry = false]) async {
            // Required for android screenshare.
            try {
              var hasPermissions = await FlutterBackground.hasPermissions;
              if (!isRetry) {
                const androidConfig = FlutterBackgroundAndroidConfig(
                  notificationTitle: 'Screen Sharing',
                  notificationText: 'LiveKit Example is sharing the screen.',
                  notificationImportance: AndroidNotificationImportance.Default,
                  notificationIcon: AndroidResource(
                      name: 'livekit_ic_launcher', defType: 'mipmap'),
                );
                hasPermissions = await FlutterBackground.initialize(
                    androidConfig: androidConfig);
              }
              if (hasPermissions &&
                  !FlutterBackground.isBackgroundExecutionEnabled) {
                await FlutterBackground.enableBackgroundExecution();
              }
            } catch (e) {
              if (!isRetry) {
                return await Future<void>.delayed(const Duration(seconds: 1),
                    () => requestBackgroundPermission(true));
              }
              print('could not publish video: $e');
            }
          }

          await requestBackgroundPermission();
        }
        await _shareScreen(null);
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> _shareScreen(DesktopCapturerSource? source) async {
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    setState(() {
      selected_source_ = source;
    });

    try {
      var stream =
          await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
        'video': selected_source_ == null
            ? {
                'mandatory': {
                  'frameRate': 15.0,
                  'minWidth': 640,
                  'minHeight': 480,
                },
              }
            : {
                'deviceId': {'exact': selected_source_!.id},
                'mandatory': {
                  'frameRate': 15.0,
                  'minWidth': 640,
                  'minHeight': 480,
                },
              }
      });
      stream.getVideoTracks()[0].onEnded = () {
        _stop();
      };
      _prevStream = _localStream;
      _screenStream = stream;
      _localRTCVideoRenderer.srcObject = _screenStream;
      /*for (var oldTrack in _localStream!.getTracks()) {
        _localStream!.removeTrack(oldTrack);
        oldTrack.dispose();
      }

      for (var newTrack in stream.getTracks()) {
        _localStream!.addTrack(newTrack);
      }*/
      switchToScreenSharing(stream);
      // Add the new stream to the peer connection
      //_rtcPeerConnection!.addStream(_localStream!);

      //_localStream = _screenStream;
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;
    isScreenSharing = true;
    setState(() {});
  }

  void switchToScreenSharing(MediaStream stream) {
    if (_localStream != null) {
      _senders.forEach((sender) {
        if (sender.track!.kind == 'video') {
          sender.replaceTrack(stream.getVideoTracks()[0]);
        }
      });
      //onLocalStream?.call(stream);
    }
  }

  Future<void> _stop() async {
    try {
      switchToScreenSharing(_prevStream!);
      if (_screenStream != null) {
        for (var track in _screenStream!.getTracks()) {
          track.stop();
        }
        _screenStream?.dispose();
      }
      _screenStream = null;
      _localRTCVideoRenderer.srcObject = _localStream;

      setState(() {
        isScreenSharing = false;
      });
    } catch (e) {
      print(e.toString());
    }
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
                isCallAccepted
                    ? RTCVideoView(
                        _remoteRTCVideoRenderer,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                      )
                    : Center(
                        child: Text(
                          'Calling ${widget.calleeId}...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: SizedBox(
                    height: 150,
                    width: 120,
                    child: RTCVideoView(
                      _localRTCVideoRenderer,
                      mirror: isFrontCameraSelected,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
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
                    if (widget.isVideo == null || widget.isVideo == true)
                      IconButton(
                        icon: const Icon(Icons.cameraswitch),
                        onPressed: _switchCamera,
                      ),
                    if (widget.isVideo == null || widget.isVideo == true)
                      IconButton(
                        icon: Icon(
                            isVideoOn ? Icons.videocam : Icons.videocam_off),
                        onPressed: _toggleCamera,
                      ),
                    if (widget.isVideo == null || widget.isVideo == true)
                      IconButton(
                        onPressed: () async {
                          print(isScreenSharing);
                          if (!isScreenSharing) {
                            await selectScreenSourceDialog(context);
                          } else {
                            await _stop();
                          }
                        },
                        icon: Icon(isScreenSharing ? Icons.tv : Icons.tv_off),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_localRTCVideoRenderer != null) {
      _localRTCVideoRenderer.dispose();
    }
    if (_remoteRTCVideoRenderer != null) {
      _remoteRTCVideoRenderer.dispose();
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
    if (_rtcPeerConnection != null) {
      _rtcPeerConnection?.dispose();
    }
    widget.socket!.off("callEnded");
    widget.socket!.off("IceCandidate");
    widget.socket!.off("callAnswered");
    cancelCallTimeout();
    super.dispose();
  }
}
