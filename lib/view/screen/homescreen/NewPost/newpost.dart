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
  List<Map<String, String>> imageList = [];
  List<Map<String, String>> videoList = [];

  String? postImageBytes;
  String? postImageBytesName;
  String? postImageExt;
  ////// for video
  String? postVideoBytes;
  String? postVideoBytesName;
  String? postVideoExt;
  VideoPlayerController? _Vcontroller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
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
                              videoList,
                              imageList,
                             
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
                        image: (controller.postImageBytes.isNotEmpty &&
                                controller.postVideoBytes == null)
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(
                                  base64Decode(controller.postImageBytes.value),
                                ),
                              )
                            : null,
                      ),
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
                                    allowMultiple: true,
                                  );

                                  if (result != null &&
                                      result.files.isNotEmpty) {
                                    List<PlatformFile> files = result.files;

                                    for (PlatformFile file in files) {
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
                                          base64String =
                                              base64Encode(fileBytes);
                                        }

                                        // Add information about each selected image to the list
                                        imageList.add({
                                          'postImageBytes': base64String,
                                          'postImageBytesName': file.name,
                                          'postImageExt': file.extension ?? '',
                                        });
                                        print("the values i have");
                                        print(imageList);
                                        postImageBytes = base64String;
                                        postImageBytesName = file.name;
                                        postImageExt = file.extension;

                                        controller.updateProfileImage(
                                          base64String,
                                          file.name,
                                          file.extension ?? '',
                                        );
                                      }
                                    }
                                  } else {
                                    controller.updateProfileImage('', '', '');
                                  }
                                } catch (err) {
                                  print(err);
                                }
                              },
                              child: Row(
                                children: [
                                  if (postImageBytes != null)
                                  
                                    Icon(
                                      Icons.cancel,
                                      size: 45,
                                      color: Colors.red,
                                    )
                                  else
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
                                if (postVideoBytes != null) {
                                  // User cancels the video selection
                                  setState(() {
                                    postVideoBytes = null;
                                    postVideoBytesName = null;
                                    postVideoExt = null;
                                  });
                                } else {
                                  // Open file picker for video
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['mp4', 'avi', 'mov'],
                                    allowMultiple:
                                        true, // Set to true to allow multiple file selection
                                  );

                                  if (result != null &&
                                      result.files.isNotEmpty) {
                                    for (PlatformFile file in result.files) {
                                      if (file.extension == "mp4" ||
                                          file.extension == "avi" ||
                                          file.extension == "mov") {
                                        // Process each selected video
                                        String base64String;
                                        if (kIsWeb) {
                                          final fileBytes = file.bytes;
                                          base64String = base64Encode(
                                              fileBytes as List<int>);
                                        } else {
                                          List<int> fileBytes =
                                              await File(file.path!)
                                                  .readAsBytes();
                                          base64String =
                                              base64Encode(fileBytes);
                                        }

                                        setState(() {
                                          postVideoBytes = base64String;
                                          postVideoBytesName = file.name;
                                          postVideoExt = file.extension;

                                          // To save more videos
                                          videoList.add({
                                            'postVideoBytes': postVideoBytes!,
                                            'postVideoBytesName':
                                                postVideoBytesName!,
                                            'postVideoExt': postVideoExt!,
                                          });
                                          print("videoooooooooo777");
                                          print(videoList);

                                          controller.updateVideo(
                                            base64String,
                                            file.name,
                                            file.extension ?? '',
                                          );

                                          print("aws2222");
                                          print(controller.postVideoBytes);
                                          print(postVideoBytesName);
                                          print(postVideoExt);
                                        });
                                      } else {
                                        // File is not a video
                                        setState(() {
                                          postVideoBytes = null;
                                          postVideoBytesName = null;
                                          postVideoExt = null;
                                        });
                                      }
                                    }
                                  } else {
                                    // User canceled the picker
                                    setState(() {
                                      postVideoBytes = null;
                                      postVideoBytesName = null;
                                      postVideoExt = null;
                                    });
                                  }
                                }
                              } catch (err) {
                                print(err);
                                setState(() {
                                  postVideoBytes = null;
                                  postVideoBytesName = null;
                                  postVideoExt = null;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                (postVideoBytes != null)
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
