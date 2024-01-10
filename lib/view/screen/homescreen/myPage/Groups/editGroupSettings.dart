import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/editsettinggroup_controller.dart';
import 'package:growify/controller/home/ProfileSettings_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/core/functions/validinput.dart';
import 'package:growify/global.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditGroupSettingSettings extends StatelessWidget {
  EditGroupSettingSettings({super.key, required this.userData}) {
    _controller1.text = userData[0]["id"].toString();
    _controller2.text = (userData[0]["description"] == null) ? "" : userData[0]["description"];
    _controller3.text = userData[0]["name"];
    _controller4.text = (userData[0]["parentNode"] == null) ? "" : userData[0]["parentNode"].toString();
    MemberSendMessages=userData[0]["membersendmessage"];
    pageId=userData[0]["id"];
    groupId=userData[0]["id"];

    controller.textFieldText.value = _controller1.text;
    controller.textFieldText2.value = _controller2.text;
    controller.textFieldText3.value = _controller3.text;
    controller.parentNode.value = _controller4.text;

    controller.update();
  }

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey();
  final List<Map<String, dynamic>> userData;
 late int pageId;
 late int groupId;

  bool? MemberSendMessages;


  EditGroupSettingsControllerImp controller =
      Get.put(EditGroupSettingsControllerImp());

  @override
  Widget build(BuildContext context) {
    

    controller.isTextFieldValueCheckBox.value=MemberSendMessages!;


    return WillPopScope(
      onWillPop: () async {
        controller.isTextFieldEnabledGroupId.value = false;
        controller.isTextFieldEnabledDescription.value = false;
        controller.isTextFieldEnabledGroupName.value = false;
        controller.isTextFieldEnabledParentGroup.value = false;
        controller.isTextFieldEnabledCheckBox.value = false;
        print("obaida");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile Settings",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formstate,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Obx(
                        () => Row(
                          children: [
                            Container(
                              width: 300,
                              margin: const EdgeInsets.only(right: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  controller: _controller1,
                                  enabled: controller
                                      .isTextFieldEnabledGroupId.value,
                                  onChanged: (value) {
                                    controller.textFieldText.value = value;
                                  },
                                  validator: (Value) {
                                    return validInput(
                                        Value!, 50, 1, "username");
                                  },
                                  decoration: InputDecoration(
                                    hintText: controller.textFieldText.value,
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 30),
                                    label: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 9),
                                        child: const Text("Group id")),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      Obx(
                        () => Row(
                          children: [
                            Container(
                              width: 300,
                              margin: const EdgeInsets.only(right: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  controller: _controller4,
                                  enabled: controller
                                      .isTextFieldEnabledParentGroup.value,
                                  onChanged: (value) {
                                    controller.parentNode.value  = value;
                                  },
                                  validator: (Value) {
                                    return validInput(
                                        Value!, 50, 1, "username");
                                  },
                                  decoration: InputDecoration(
                                    hintText: controller.parentNode.value ,
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 30),
                                    label: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 9),
                                        child: const Text("Parent Group")),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    

                      const SizedBox(height: 20),
                      Obx(
                        () => Row(
                          children: [
                            Container(
                              width: 300,
                              margin: const EdgeInsets.only(right: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  maxLines: 6,
                                  controller: _controller2,
                                  enabled: controller
                                      .isTextFieldEnabledDescription.value,
                                  onChanged: (text) {
                                    controller.textFieldText2.value = text;
                                  },
                                  validator: (Value) {
                                    return validInput(
                                        Value!, 50, 1, "username");
                                  },
                                  decoration: InputDecoration(
                                    hintText: controller.textFieldText2.value,
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 30),
                                    label: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 9),
                                        child: const Text("Description")),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                controller.isTextFieldEnabledDescription
                                    .toggle();
                                _controller2.text =
                                    controller.textFieldText2.value;
                                controller.update();
                              },
                              icon: const Icon(Icons.edit),
                              color:
                                  controller.isTextFieldEnabledDescription.value
                                      ? Colors.blue
                                      : Colors.grey,
                            )
                          ],
                        ),
                      ),

                      //////////////////
                      const SizedBox(height: 20),
                      Obx(
                        () => Row(
                          children: [
                            Container(
                              width: 300,
                              margin: const EdgeInsets.only(right: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  controller: _controller3,
                                  enabled: controller
                                      .isTextFieldEnabledGroupName.value,
                                  onChanged: (text) {
                                    controller.textFieldText3.value = text;
                                  },
                                  validator: (Value) {
                                    return validInput(Value!, 50, 1, "length");
                                  },
                                  decoration: InputDecoration(
                                    hintText: controller.textFieldText3.value,
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 30),
                                    label: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 9),
                                        child: const Text("Group Name")),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Edit the enable of the textfiled
                                controller.isTextFieldEnabledGroupName.toggle();
                                _controller3.text =
                                    controller.textFieldText3.value;
                                controller.update();
                              },
                              icon: const Icon(Icons.edit),
                              color:
                                  controller.isTextFieldEnabledGroupName.value
                                      ? Colors.blue
                                      : Colors.grey,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => Row(
                          children: [
                            Container(
                              width: 300,
                              margin: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Member Can Send Messages',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                  Checkbox(
                                    value: controller
                                        .isTextFieldValueCheckBox.value,
                                    onChanged: controller
                                            .isTextFieldEnabledCheckBox.value
                                        ? (value) {
                                            controller.isTextFieldValueCheckBox
                                                .toggle();
                                            controller.update();
                                          }
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Edit the enable of the checkbox
                                controller.isTextFieldEnabledCheckBox.toggle();
                                controller.update();
                              },
                              icon: const Icon(Icons.edit),
                              color: controller.isTextFieldEnabledCheckBox.value
                                  ? Colors.blue
                                  : Colors.grey,
                            )
                          ],
                        ),
                      ),

                      //////////////////
                      const SizedBox(height: 180),

                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 135),
                        onPressed: () async {
                          controller.postSaveChanges(pageId,groupId);
                        },
                        color: const Color.fromARGB(255, 85, 191, 218),
                        textColor: Colors.white,
                        child: const Text("Save Changes"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
