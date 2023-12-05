import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/ProfileSettings_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/core/functions/validinput.dart';
import 'package:growify/global.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfileSettings extends StatelessWidget {
  ProfileSettings({super.key, required this.userData}) {
    _controller1.text = userData[0]["firstname"];
    _controller2.text = userData[0]["lastname"];
    _controller3.text =
        (userData[0]["address"] == null) ? "" : userData[0]["address"];
    _controller4.text =
        (userData[0]["country"] == null) ? "" : userData[0]["country"];
    controller.startDateController.text = userData[0]["dateOfBirth"];
    _controller6.text = userData[0]["phone"];
    _controller7.text = (userData[0]["bio"] == null) ? "" : userData[0]["bio"];
    profileImage = (userData[0]["photo"] == null) ? "" : userData[0]["photo"];
    coverImage =
        (userData[0]["coverImage"] == null) ? "" : userData[0]["coverImage"];
    // Set initial values in the controller
    controller.textFieldText.value = _controller1.text;
    controller.textFieldText2.value = _controller2.text;
    controller.textFieldText3.value = _controller3.text;
    controller.country.value = _controller4.text;
    controller.textFieldText5.value = controller.startDateController.text;
    controller.textFieldText6.value = _controller6.text;
    controller.textFieldText7.value = _controller7.text;

    controller.update();
  }

  final AssetImage defultprofileImage = const AssetImage("images/profileImage.jpg");
  String? profileImageBytes;
  String? profileImageBytesName;
  String? profileImageExt;
  String? coverImageBytes;
  String? coverImageBytesName;
  String? coverImageExt;
  String? cvBytes;
  String? cvName;
  String? cvExt;
  String? profileImage;
  String? coverImage;
  ImageProvider<Object>? profileBackgroundImage;
  late ImageProvider<Object> coverBackgroundImage;

  final AssetImage defultcoverImage = const AssetImage("images/coverImage.jpg");
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  // final TextEditingController _controller5 = TextEditingController();
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

    profileBackgroundImage = (profileImage != null && profileImage != "")
        ? Image.network("$urlStarter/" + profileImage!).image
        : defultprofileImage;

    coverBackgroundImage = (coverImage != null && coverImage != "")
        ? Image.network("$urlStarter/" + coverImage!).image
        : defultcoverImage;
    return WillPopScope(
      onWillPop: () async {
        // Your custom logic here
        // For example, show a confirmation dialog
        controller.isTextFieldEnabled.value=false;
        controller.isTextFieldEnabled2.value=false;
        controller.isTextFieldEnabled3.value=false;
        controller.isTextFieldEnabled5.value=false;
        controller.isTextFieldEnabled6.value=false;
        controller.isTextFieldEnabled7.value=false;
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
                      GetBuilder<ProfileSettingsControllerImp>(
                        builder: (controller) => Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: controller
                                      .profileImageBytes.isNotEmpty
                                  ? MemoryImage(base64Decode(
                                      controller.profileImageBytes.value))
                                  : profileBackgroundImage, // Replace with your default photo URL
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 85, 191, 218),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                onPressed: () async {
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
                                        profileImageBytes=base64String;
                                        profileImageBytesName=file.name;
                                        profileImageExt=file.extension;
                                        

                             
                                        controller.updateProfileImage(
                                          base64String,
                                          file.name,
                                          file.extension ??
                                              '', // Use the null-aware operator
                                        );
                                      } else {
                                        controller.updateProfileImage('', '', '');
                                      }
                                    } else {
                                      // User canceled the picker
                                      controller.updateProfileImage('', '', '');
                                    }
                                  } catch (err) {
                                    print(err);
                                  }
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
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
    
                    
    
                      /*  Obx(
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
                      ),*/
    
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
                                  // controller: _controller5,
                                  controller: controller.startDateController,
                                  readOnly: true,
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
                                        child: const Text("DateOfBirth")),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.date_range),
                                      onPressed: () =>
                                          controller.pickStartDate(context),
                                    ),
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
                                controller.startDateController.text =
                                    controller.textFieldText5.value;
                                controller.update();
                              },
                              icon: const Icon(Icons.edit),
                              color: controller.isTextFieldEnabled5.value
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
                                        child: const Text("Phone")),
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
                              icon: const Icon(Icons.edit),
                              color: controller.isTextFieldEnabled6.value
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
                                        child: const Text("Bio")),
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
                              icon: const Icon(Icons.edit),
                              color: controller.isTextFieldEnabled7.value
                                  ? Colors.blue
                                  : Colors.grey,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
    
                      Container(
                        child: const Text(
                          "Cover Page",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // change cover page
                      Row(
                        children: [
                          GetBuilder<ProfileSettingsControllerImp>(
                            builder: (controller) => Stack(
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
                                      image: controller.coverImageBytes.isNotEmpty
                                          ? MemoryImage(base64Decode(
                                              controller.coverImageBytes.value))
                                          : coverBackgroundImage, // Replace with your default photo URL
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 85, 191, 218),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      try {
                                        final result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: [
                                            'jpg',
                                            'jpeg',
                                            'png'
                                          ],
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
                                              base64String =
                                                  base64Encode(fileBytes);
                                            }

                                            coverImageBytes=base64String;
                                            coverImageBytesName=file.name;
                                            coverImageExt=file.extension;

   
                                            controller.updateCoverImage(
                                              base64String,
                                              file.name,
                                              file.extension ??
                                                  '', // Use the null-aware operator
                                            );
                                          } else {
                                            controller.updateCoverImage(
                                                '', '', '');
                                          }
                                        } else {
                                          // User canceled the picker
                                          controller.updateCoverImage('', '', '');
                                        }
                                      } catch (err) {
                                        print(err);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
    
                      const SizedBox(height: 20),
    
                      Container(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                              allowMultiple: false,
                            );
    
                            if (result != null && result.files.isNotEmpty) {
                              PlatformFile file = result.files.first;
                              if (file.extension == "pdf") {
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
                                cvBytes = base64String;
                                cvName = file.name;
                                cvExt = file.extension;
                              } else {
                                cvBytes = null;
                                cvName = null;
                                cvExt = null;
                              }
                            } else {
                              // User canceled the picker
                              cvBytes = null;
                              cvName = null;
                              cvExt = null;
                            }
                          },
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text('Upload CV'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 85, 191, 218),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 130, vertical: 13),
                          ),
                        ),
                      ),
    
                      const SizedBox(height: 20),
    
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 135),
                        onPressed: () async {
                          var message = await controller.SaveChanges(
                              profileImageBytes,
                              profileImageBytesName,
                              profileImageExt,
                              coverImageBytes,
                              coverImageBytesName,
                              coverImageExt,
                              cvBytes,
                              cvName,
                              cvExt);
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
