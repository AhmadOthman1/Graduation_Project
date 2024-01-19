import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/OptionAboutPost_Controller/editPostUser_controller.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/global.dart';

class EditPost extends StatelessWidget {
  final profileImage;
  final postId;
  final postContent;
  final selectedPrivacy;

  EditPost({
    Key? key,
    this.postId,
    this.postContent,
    this.selectedPrivacy, this.profileImage,
  }) : super(key: key);

  String? postImageBytes;
  String? postImageBytesName;
  String? postImageExt;

  final EditPostUserControllerImp controller = Get.put(EditPostUserControllerImp());
  GlobalKey<FormState> formstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> profileBackgroundImage =
        (profileImage != null && profileImage != "")
            ? Image.network("$urlStarter/$profileImage").image
            : const AssetImage("images/profileImage.jpg");

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: GetBuilder<EditPostUserControllerImp>(
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
                        value: controller.selectedPrivacy.value ?? selectedPrivacy,
                        items: [
                          'Any One',
                          'Connections',
                        ]
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
                            var message = await controller.post(postId);
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
                          "Edit",
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: formstate,
                    child: TextFormField(
                      initialValue: postContent,
                      onChanged: (value) =>
                          controller.postContent.value = value,
                      onFieldSubmitted: (value) {
                        controller.postContent.value += '\n';
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<EditPostUserControllerImp>(
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
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 145),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
