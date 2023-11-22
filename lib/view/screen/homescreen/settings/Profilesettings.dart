import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/ProfileSettings_controller.dart';
import 'package:growify/core/functions/validinput.dart';
import 'package:growify/view/widget/auth/ButtonAuth.dart';
import 'package:growify/view/widget/auth/textFormAuth.dart';
import 'package:file_picker/file_picker.dart';

class ProfileSettings extends StatelessWidget {
  ProfileSettings({Key? key, required this.userData}) {
    _controller1.text = userData[0]["name"];
    _controller2.text = userData[0]["lastname"];
    _controller3.text = userData[0]["address"];
    _controller4.text = userData[0]["country"];
    _controller5.text = userData[0]["dateOfBirth"];
    _controller6.text = userData[0]["phone"];
    _controller7.text = userData[0]["bio"];

    // Set initial values in the controller
    controller.textFieldText.value = _controller1.text;
    controller.textFieldText2.value = _controller2.text;
    controller.textFieldText3.value = _controller3.text;
    controller.textFieldText4.value = _controller4.text;
    controller.textFieldText5.value = _controller5.text;
    controller.textFieldText6.value = _controller6.text;
    controller.textFieldText7.value = _controller7.text;

    controller.update();
  }
  final AssetImage _profileImage = AssetImage("images/obaida.jpeg");
  List<int>? profileImageBytes;
  String? profileImageBytesName;
  String? profileImageExt;
  List<int>? coverImageBytes;
  String? coverImageBytesName;
  String? coverImageExt;
  List<int>? cvBytes ;
  String? cvName ;
  String? cvExt ;
  final AssetImage _coverImage = AssetImage("images/flutterimage.png");
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();
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

  ProfileSettingsControllerImp controller =
      Get.put(ProfileSettingsControllerImp());

  @override
  Widget build(BuildContext context) {
    Firstname = userData[0]["name"];
    Lastname = userData[0]["lastname"];
    Address = userData[0]["address"];
    Country = userData[0]["country"];
    DateOfBirth = userData[0]["dateOfBirth"];
    Phone = userData[0]["phone"];
    Bio = userData[0]["bio"];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Settings",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
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
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                _profileImage // Replace with your photo URL
                            ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 85, 191, 218),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['jpg', 'jpeg', 'png'],
                              );

                              if (result != null) {
                                PlatformFile file = result.files.first;
                                if (file.extension == "jpg" ||
                                    file.extension == "jpeg" ||
                                    file.extension == "png") {
                                  print(file.name);
                                  //print(file.bytes);
                                  print(file.size);
                                  print(file.extension);
                                  print(file.path);
                                  profileImageBytes = file.bytes!.cast();
                                  // * Get its name, will use it later.
                                  profileImageBytesName = file.name;
                                  profileImageExt=file.extension;
                                  // * Send it to method that will make HTTP request.
                                  //_projectProvider.test(bytes, name);
                                } else {
                                  profileImageBytes = null;
                                  profileImageBytesName = null;
                                  profileImageExt=null;
                                }
                              } else {
                                // User canceled the picker
                                profileImageBytes = null;
                                profileImageBytesName = null;
                                profileImageExt=null;
                              }
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Obx(
                      () => Row(
                        children: [
                          Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 10),
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
                                      child: Text("Firstname")),
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
                            icon: Icon(Icons.edit),
                            color: controller.isTextFieldEnabled.value
                                ? Colors.blue
                                : Colors.grey,
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                    Obx(
                      () => Row(
                        children: [
                          Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 10),
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
                                      child: Text("Lastname")),
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
                            icon: Icon(Icons.edit),
                            color: controller.isTextFieldEnabled2.value
                                ? Colors.blue
                                : Colors.grey,
                          )
                        ],
                      ),
                    ),

                    //////////////////
                    SizedBox(height: 20),
                    Obx(
                      () => Row(
                        children: [
                          Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 10),
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
                                      child: Text("Address")),
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
                            icon: Icon(Icons.edit),
                            color: controller.isTextFieldEnabled3.value
                                ? Colors.blue
                                : Colors.grey,
                          )
                        ],
                      ),
                    ),
                    //////////////////
                    SizedBox(height: 20),
                    Obx(
                      () => Row(
                        children: [
                          Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                controller: _controller4,
                                enabled: controller.isTextFieldEnabled4.value,
                                onChanged: (text) {
                                  controller.textFieldText4.value = text;
                                },
                                validator: (Value) {
                                  return validInput(Value!, 50, 5, "length");
                                },
                                decoration: InputDecoration(
                                  hintText: controller.textFieldText4.value,
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
                                      child: Text("Country")),
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
                              controller.isTextFieldEnabled4.toggle();
                              _controller4.text =
                                  controller.textFieldText4.value;
                              controller.update();
                            },
                            icon: Icon(Icons.edit),
                            color: controller.isTextFieldEnabled4.value
                                ? Colors.blue
                                : Colors.grey,
                          )
                        ],
                      ),
                    ),

                    //////////////////
                    SizedBox(height: 20),
                    Obx(
                      () => Row(
                        children: [
                          Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                controller: _controller5,
                                enabled: controller.isTextFieldEnabled5.value,
                                onChanged: (text) {
                                  controller.textFieldText5.value = text;
                                },
                                validator: (Value) {
                                  return validInput(
                                      Value!, 10, 8, "dateOfBirth");
                                },
                                decoration: InputDecoration(
                                  hintText: controller.textFieldText5.value,
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
                                      child: Text("DateOfBirth")),
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
                              controller.isTextFieldEnabled5.toggle();
                              _controller5.text =
                                  controller.textFieldText5.value;
                              controller.update();
                            },
                            icon: Icon(Icons.edit),
                            color: controller.isTextFieldEnabled5.value
                                ? Colors.blue
                                : Colors.grey,
                          )
                        ],
                      ),
                    ),

                    //////////////////
                    SizedBox(height: 20),
                    Obx(
                      () => Row(
                        children: [
                          Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                controller: _controller6,
                                enabled: controller.isTextFieldEnabled6.value,
                                onChanged: (text) {
                                  controller.textFieldText6.value = text;
                                },
                                validator: (Value) {
                                  return validInput(Value!, 15, 10, "phone");
                                },
                                decoration: InputDecoration(
                                  hintText: controller.textFieldText6.value,
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
                                      child: Text("Phone")),
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
                              controller.isTextFieldEnabled6.toggle();
                              _controller6.text =
                                  controller.textFieldText6.value;
                              controller.update();
                            },
                            icon: Icon(Icons.edit),
                            color: controller.isTextFieldEnabled6.value
                                ? Colors.blue
                                : Colors.grey,
                          )
                        ],
                      ),
                    ),

                    //////////////////
                    SizedBox(height: 20),
                    Obx(
                      () => Row(
                        children: [
                          Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                controller: _controller7,
                                enabled: controller.isTextFieldEnabled7.value,
                                onChanged: (text) {
                                  controller.textFieldText7.value = text;
                                },
                                validator: (Value) {
                                  return validInput(Value!, 250, 1, "length");
                                },
                                decoration: InputDecoration(
                                  hintText: controller.textFieldText7.value,
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
                                      child: Text("Bio")),
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
                              controller.isTextFieldEnabled7.toggle();
                              _controller7.text =
                                  controller.textFieldText7.value;
                              controller.update();
                            },
                            icon: Icon(Icons.edit),
                            color: controller.isTextFieldEnabled7.value
                                ? Colors.blue
                                : Colors.grey,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    Container(
                      child: Text(
                        "Cover Page",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 5),
                    // change cover page
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 350,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _coverImage,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 85, 191, 218),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['jpg', 'jpeg', 'png'],
                                  );

                                  if (result != null) {
                                    PlatformFile file = result.files.first;
                                    if (file.extension == "jpg" ||
                                        file.extension == "jpeg" ||
                                        file.extension == "png") {
                                      print(file.name);
                                      //print(file.bytes);
                                      print(file.size);
                                      print(file.extension);
                                      print(file.path);
                                      coverImageBytes = file.bytes!.cast();
                                      // * Get its name, will use it later.
                                      coverImageBytesName = file.name;
                                      coverImageExt=file.extension;
                                      // * Send it to method that will make HTTP request.
                                      //_projectProvider.test(bytes, name);
                                    } else {
                                      coverImageBytes = null;
                                      coverImageBytesName = null;
                                      coverImageExt=null;
                                    }
                                  } else {
                                    // User canceled the picker
                                    coverImageBytes = null;
                                    coverImageBytesName = null;
                                    coverImageExt=null;
                                  }
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Container(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );

                          if (result != null) {
                            PlatformFile file = result.files.first;
                            if (file.extension == "pdf") {
                              print(file.name);
                              //print(file.bytes);
                              print(file.size);
                              print(file.extension);
                              print(file.path);
                              cvBytes = file.bytes!.cast();
                              // * Get its name, will use it later.
                              cvName = file.name;
                              cvExt=file.extension;
                              // * Send it to method that will make HTTP request.
                              //_projectProvider.test(bytes, name);
                            } else {
                              cvBytes = null;
                              cvName = null;
                              cvExt=null;
                            }
                          } else {
                            // User canceled the picker
                            cvBytes = null;
                            cvName = null;
                            cvExt=null;
                          }
                        },
                        icon: Icon(Icons.cloud_upload),
                        label: Text('Upload CV'),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 85, 191, 218),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 130, vertical: 13),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 135),
                      onPressed: () {
                        
                      },
                      color: Color.fromARGB(255, 85, 191, 218),
                      textColor: Colors.white,
                      child: Text("Save Changes"),
                    ),
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
