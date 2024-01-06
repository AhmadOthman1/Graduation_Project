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
    _controller1.text = "aaaaaaa";//userData[0]["firstname"];
    _controller2.text = "aaaaaaa";//userData[0]["lastname"];
    _controller3.text ="kkkk";
      //  (userData[0]["address"] == null) ? "" : userData[0]["address"];
    _controller4.text ="Palestine";
      //  (userData[0]["country"] == null) ? "" : userData[0]["country"];

    
    _controller7.text = "hi";
    //(userData[0]["bio"] == null) ? "" : userData[0]["bio"];

    // Set initial values in the controller
    controller.textFieldText.value = _controller1.text;
    controller.textFieldText2.value = _controller2.text;
    controller.textFieldText3.value = _controller3.text;
    controller.country.value = _controller4.text;
 

    controller.update();
  }

  
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller7 = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  final List<Map<String, dynamic>> userData;
  String? Firstname;
  String? Lastname;
  String? Address;
  String? Country;
  String? DateOfBirth;
  String? Phone;
  String? Bio;

  EditGroupSettingsControllerImp controller =
      Get.put(EditGroupSettingsControllerImp());


  @override
  Widget build(BuildContext context) {
    Firstname = "kkkkkkkkk";
    //userData[0]["name"];
    Lastname = "kkkkk";
   // userData[0]["lastname"];
    Address = "lwkm lmwc";
   // userData[0]["address"];
    Country = "Palestine";
    //userData[0]["country"];



    return WillPopScope(
      onWillPop: () async {
        controller.isTextFieldEnabled.value=false;
        controller.isTextFieldEnabled2.value=false;
        controller.isTextFieldEnabled3.value=false;
        controller.isTextFieldEnabled11.value=false;
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
                                  enabled: controller.isTextFieldEnabled.value,
                                  onChanged: (value) {
                                    controller.textFieldText.value = value;
                                  },
                                  validator: (Value) {
                                    return validInput(Value!, 50, 1, "username");
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
                                        child: const Text("Firstname")),
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
                                controller.isTextFieldEnabled.toggle();
                                _controller1.text =
                                    controller.textFieldText.value;
                                controller.update();
                              },
                              icon: const Icon(Icons.edit),
                              color: controller.isTextFieldEnabled.value
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
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  controller: _controller2,
                                  enabled: controller.isTextFieldEnabled2.value,
                                  onChanged: (text) {
                                    controller.textFieldText2.value = text;
                                  },
                                  validator: (Value) {
                                    return validInput(Value!, 50, 1, "username");
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
                                        child: const Text("Lastname")),
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
                                controller.isTextFieldEnabled2.toggle();
                                _controller2.text =
                                    controller.textFieldText2.value;
                                controller.update();
                              },
                              icon: const Icon(Icons.edit),
                              color: controller.isTextFieldEnabled2.value
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
                                  enabled: controller.isTextFieldEnabled3.value,
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
                                        child: const Text("Address")),
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
                                controller.isTextFieldEnabled3.toggle();
                                _controller3.text =
                                    controller.textFieldText3.value;
                                controller.update();
                              },
                              icon: const Icon(Icons.edit),
                              color: controller.isTextFieldEnabled3.value
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
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
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
                                      child: const Text("Your Country"),
                                    ),
                                  ),
                                  isExpanded: true,
                                  hint: const Text('Select Country',
                                      style: TextStyle(color: Colors.grey)),
                                  items: controller.countryList.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  value: controller.country.value.isEmpty
                                      ? null
                                      : controller.country.value,
                                  onChanged: controller.isTextFieldEnabled11.value
                                      ? (value) {
                                          controller.country.value =
                                              value.toString();
                                          print(controller.country.value);
                                        }
                                      : null, // Disable the dropdown when not enabled
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select country';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Toggle the enable state of the dropdown
                                controller.isTextFieldEnabled11.toggle();
                              },
                              icon: const Icon(Icons.edit),
                              color: controller.isTextFieldEnabled11.value
                                  ? Colors.blue
                                  : Colors.grey,
                            )
                          ],
                        ),
                      ),
    
                     
    
                      const SizedBox(height: 20),
    
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 135),
                        onPressed: () async {
                          
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
