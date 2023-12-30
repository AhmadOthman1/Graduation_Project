import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/newpost_controller.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:growify/core/functions/alertbox.dart';

class NewPost extends StatelessWidget {
  NewPost({super.key});

  String? postImageBytes;
  String? postImageBytesName;
  String? postImageExt;

  ImageProvider<Object>? postBackgroundImage;

  final NewPostControllerImp controller = Get.put(NewPostControllerImp());
  GlobalKey<FormState> formstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Set postBackgroundImage to null initially
    postBackgroundImage = null;

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
                          child: const CircleAvatar(
                            backgroundImage: AssetImage(
                              'images/obaida.jpeg',
                            ),
                            radius: 20,
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        value: controller.selectedPrivacy.value,
                        items: [
                          'Any One',
                          'Connections',
                        ] // Add more options as needed
                            .map((String privacyOption) {
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
                            : null, // Set image to null initially
                      ),
                    ),
                  ),
                  const SizedBox(height: 145),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(
                        color: Color.fromARGB(255, 194, 193, 193),
                        thickness: 1.5,
                      ),
                      InkWell(
                        onTap: () async {
                          try {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'jpeg', 'png'],
                              allowMultiple: false,
                            );
                            if (result != null && result.files.isNotEmpty) {
                              PlatformFile file = result.files.first;
                              if (file.extension == "jpg" ||
                                  file.extension == "jpeg" ||
                                  file.extension == "png") {
                                String base64String;
                                if (kIsWeb) {
                                  final fileBytes = file.bytes;
                                  base64String =
                                      base64Encode(fileBytes as List<int>);
                                } else {
                                  List<int> fileBytes =
                                      await File(file.path!).readAsBytes();
                                  base64String = base64Encode(fileBytes);
                                }
                                postImageBytes = base64String;
                                postImageBytesName = file.name;
                                postImageExt = file.extension;

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
                            Text(
                              "Add Photo",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Icon(
                              Icons.image,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 194, 193, 193),
                        thickness: 1.5,
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
