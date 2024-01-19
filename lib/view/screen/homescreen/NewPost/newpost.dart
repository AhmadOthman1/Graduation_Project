import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/newpost_controller.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/global.dart';
import 'package:video_player/video_player.dart';

class NewPost extends StatefulWidget {
  final String? profileImage;
  final bool? isPage;
  final String? pageId;

  NewPost({Key? key, this.profileImage, this.isPage, this.pageId})
      : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  String? postImageBytes;
  String? postImageBytesName;
  String? postImageExt;
  ////// for video
  String? messageVideoBytes;
  String? messageVideoBytesName;
  String? messageVideoExt;
  VideoPlayerController? _Vcontroller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
  
  }

    Future<void> initializeVideoPlayer() async {
    try {
      _Vcontroller = VideoPlayerController.networkUrl(
        Uri.parse("$urlStarter/${controller.messageVideoBytes}"),

      );
  
      await _Vcontroller!.initialize();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }

      _Vcontroller!.addListener(() {
        if (!_Vcontroller!.value.isInitialized) {
          // Handle initialization errors here
          print("Video initialization failed");
        }
      });
    } catch (e) {
      // Handle exceptions during video initialization
      print("Exception during video initialization: $e");
    }
  }

  final NewPostControllerImp controller = Get.put(NewPostControllerImp());
  GlobalKey<FormState> formstate = GlobalKey();
  bool showConnectionsOption = true;

  // to play video oo o o oo o o o o o oo o o oo o o o
  Widget _buildVideoPlayer() {
    return Builder(
      builder: (context) {
        if (_Vcontroller != null && _Vcontroller!.value.isInitialized) {
          return Column(
            children: [
              AspectRatio(
                aspectRatio: _Vcontroller!.value.aspectRatio,
                child: VideoPlayer(_Vcontroller!),
              ),
              VideoProgressIndicator(_Vcontroller!, allowScrubbing: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _Vcontroller!.value.isPlaying
                          ? _Vcontroller!.pause()
                          : _Vcontroller!.play();
                    },
                    icon: _Vcontroller!.value.isPlaying
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          );
        } else {
          print("that's baddddddddddddddddddddd");
          return Container();
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    if (controller.messageVideoBytes != null && !_isVideoInitialized) {
      initializeVideoPlayer(); // Don't build the message widget until the video player is initialized
    }
    ImageProvider<Object> profileBackgroundImage =
        (widget.profileImage != null && widget.profileImage != "")
            ? Image.network("$urlStarter/${widget.profileImage}").image
            : const AssetImage("images/profileImage.jpg");

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: GetBuilder<NewPostControllerImp>(
          init: controller,
          builder: (controller) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: ListView(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 5, right: 15),
                          child: const Icon(
                            Icons.close,
                            size: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2, right: 15),
                        child: InkWell(
                          onTap: () {},
                          child: CircleAvatar(
                            backgroundImage: profileBackgroundImage,
                            radius: 20,
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        value: controller.selectedPrivacy.value,
                        items: [
                          'Any One',
                          if (showConnectionsOption && widget.isPage != true)
                            'Connections',
                        ].map((String privacyOption) {
                          return DropdownMenuItem<String>(
                            value: privacyOption,
                            child: Text(privacyOption),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          controller.updatePrivacy(newValue!);
                          print('Privacy edited: $newValue');
                        },
                      ),
                      const Spacer(),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () async {
                          if (formstate.currentState!.validate()) {
                            var message = await controller.post(
                              postImageBytes,
                              postImageBytesName,
                              postImageExt,
                              messageVideoBytes,
                              messageVideoBytesName,
                              messageVideoExt,
                              widget.isPage,
                              widget.pageId,
                            );
                            (message != null)
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomAlertDialog(
                                        title: 'Error',
                                        icon: Icons.error,
                                        text: message,
                                        buttonText: 'OK',
                                      );
                                    },
                                  )
                                : null;
                          }
                        },
                        child: const Text(
                          "Post",
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: formstate,
                    child: TextFormField(
                      onChanged: (value) =>
                          controller.postContent.value = value,
                      onFieldSubmitted: (value) {
                        controller.postContent.value += '\n';
                      },
                      maxLines: null, // Allows for multiple lines
                      keyboardType:
                          TextInputType.multiline, // Enables the Enter key
                      decoration: const InputDecoration(
                        hintText: 'What do you want to talk about?',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<NewPostControllerImp>(
                    builder: (controller) => Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: (controller.postImageBytes.isNotEmpty)
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(
                                  base64Decode(controller.postImageBytes.value),
                                ),
                              )
                            : (controller.messageVideoBytes != null)
                                ? null
                                : null,
                      ),
                      child: (controller.messageVideoBytes != null)
                          ? Builder(
                              builder: (context) {
                                print("im inside it okkk");
                                print(
                                    "Video Bytes: ${controller.messageVideoBytes}");
                                print(
                                    "Video Name: ${controller.messageVideoBytesName}");
                                print(
                                    "Video Ext: ${controller.messageVideoExt}");
                                return _buildVideoPlayer();
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 145),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 100),
                            child: InkWell(
                              onTap: () async {
                                try {
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['jpg', 'jpeg', 'png'],
                                    allowMultiple: false,
                                  );
                                  if (result != null &&
                                      result.files.isNotEmpty) {
                                    PlatformFile file = result.files.first;
                                    if (file.extension == "jpg" ||
                                        file.extension == "jpeg" ||
                                        file.extension == "png") {
                                      String base64String;
                                      if (kIsWeb) {
                                        final fileBytes = file.bytes;
                                        base64String = base64Encode(
                                            fileBytes as List<int>);
                                      } else {
                                        List<int> fileBytes =
                                            await File(file.path!)
                                                .readAsBytes();
                                        base64String = base64Encode(fileBytes);
                                      }
                                      postImageBytes = base64String;
                                      postImageBytesName = file.name;
                                      postImageExt = file.extension;
                                      print("Symannnnnnnnnnnn");
                                      print(postImageBytes);

                                      controller.updateProfileImage(
                                        base64String,
                                        file.name,
                                        file.extension ?? '',
                                      );
                                    } else {
                                      controller.updateProfileImage('', '', '');
                                    }
                                  } else {
                                    controller.updateProfileImage('', '', '');
                                  }
                                } catch (err) {
                                  print(err);
                                }
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 45,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          InkWell(
                            onTap: () async {
                              try {
                                if (messageVideoBytes != null) {
                                  // User cancels the video selection
                                  setState(() {
                                    messageVideoBytes = null;
                                    messageVideoBytesName = null;
                                    messageVideoExt = null;
                                  });
                                } else {
                                  // Open file picker for video
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['mp4', 'avi', 'mov'],
                                    allowMultiple: false,
                                  );

                                  if (result != null &&
                                      result.files.isNotEmpty) {
                                    PlatformFile file = result.files.first;
                                    if (file.extension == "mp4" ||
                                        file.extension == "avi" ||
                                        file.extension == "mov") {
                                      // Process the selected video
                                      String base64String;
                                      if (kIsWeb) {
                                        final fileBytes = file.bytes;
                                        base64String = base64Encode(
                                            fileBytes as List<int>);
                                      } else {
                                        List<int> fileBytes =
                                            await File(file.path!)
                                                .readAsBytes();
                                        base64String = base64Encode(fileBytes);
                                      }

                                      setState(() {
                                        messageVideoBytes = base64String;
                                        messageVideoBytesName = file.name;
                                        messageVideoExt = file.extension;

                                        controller.updateVideo(
                                          base64String,
                                          file.name,
                                          file.extension ?? '',
                                        );

                                        print("aws2222");
                                        print(controller.messageVideoBytes);
                                        print(messageVideoBytesName);
                                        print(messageVideoExt);
                                      });
                                    } else {
                                      // File is not a video
                                      setState(() {
                                        messageVideoBytes = null;
                                        messageVideoBytesName = null;
                                        messageVideoExt = null;
                                      });
                                    }
                                  } else {
                                    // User canceled the picker
                                    setState(() {
                                      messageVideoBytes = null;
                                      messageVideoBytesName = null;
                                      messageVideoExt = null;
                                    });
                                  }
                                }
                              } catch (err) {
                                print(err);
                                setState(() {
                                  messageVideoBytes = null;
                                  messageVideoBytesName = null;
                                  messageVideoExt = null;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                (messageVideoBytes != null)
                                    ? const Icon(Icons.cancel,
                                        size: 45, color: Colors.red)
                                    : const Icon(Icons.videocam,
                                        size: 45, color: Colors.grey),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
