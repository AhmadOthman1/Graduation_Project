import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/AdminsGroup_controller.dart/AddGroupAdmin_controller.dart';
import 'package:growify/controller/home/Groups_controller/Members_controller/AddOtherMembers_controller.dart';
import 'package:growify/controller/home/myPage_Controller/Employee_Controller/AddEmployee_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/core/functions/alertbox.dart';

class AddGroupAdmin extends StatefulWidget {
  final pageId;
  final groupId;

  const AddGroupAdmin({Key? key, required this.pageId, this.groupId})
      : super(key: key);

  @override
  _AddAddGroupAdmin createState() => _AddAddGroupAdmin();
}

class _AddAddGroupAdmin extends State<AddGroupAdmin> {
  late AddGroupAdminController _controller;

  TextEditingController _usernameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AddGroupAdminController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press here
            Get.offNamed(AppRoute
                .homescreen); // This pops the current route off the stack
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Add New Admin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      if (kIsWeb)
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                      kIsWeb
                          ? Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  hintText: "Enter Username",
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 30),
                                  labelText: "Username",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a Username';
                                  }
                                  return null;
                                },
                              ),
                            )
                          : Expanded(
                            child: Container(
                                width: 350,
                                child: TextFormField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    hintText: "Enter Username",
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 30),
                                    labelText: "Username",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a Username';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                          ),
                      if (kIsWeb)
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                if (kIsWeb)
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                kIsWeb
                    ? Expanded(
                        flex: 2,
                        child: Container(
                          width: 350,
                          child: MaterialButton(
                            onPressed: () async {
                              print("*****************************");
                              print(widget.groupId);
                              print(widget.pageId);
                              print("******************************");
                              if (formKey.currentState!.validate()) {
                                if (_usernameController.text
                                    .trim()
                                    .isNotEmpty) {
                                  var message = await _controller.addAdmin(
                                      _usernameController.text.trim(),
                                      widget.groupId);
                                  (message != null)
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomAlertDialog(
                                              title: 'Alret',
                                              icon: Icons.error,
                                              text: message,
                                              buttonText: 'OK',
                                            );
                                          },
                                        )
                                      : null;
                                  _usernameController.clear();
                                }
                              }
                            },
                            color: const Color.fromARGB(255, 85, 191, 218),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Add Admin',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                      child: Container(
                          width: 350,
                          child: MaterialButton(
                            onPressed: () async {
                              print("*****************************");
                              print(widget.groupId);
                              print(widget.pageId);
                              print("******************************");
                              if (formKey.currentState!.validate()) {
                                if (_usernameController.text.trim().isNotEmpty) {
                                  var message = await _controller.addAdmin(
                                      _usernameController.text.trim(),
                                      widget.groupId);
                                  (message != null)
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomAlertDialog(
                                              title: 'Alret',
                                              icon: Icons.error,
                                              text: message,
                                              buttonText: 'OK',
                                            );
                                          },
                                        )
                                      : null;
                                  _usernameController.clear();
                                }
                              }
                            },
                            color: const Color.fromARGB(255, 85, 191, 218),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Add Admin',
                              style: TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                    ),
                if (kIsWeb)
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
