import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/myPage_Controller/Admin_controller/Page_selectAdmin_Controller.dart';
import 'package:growify/core/functions/alertbox.dart';

class AddAdmin extends StatefulWidget {
  final pageId;

  const AddAdmin({Key? key, required this.pageId}) : super(key: key);

  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  late selectAdminController _controller;

  TextEditingController _usernameController = TextEditingController();
  String? _selectedRole;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = selectAdminController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Edit/Add Admin',
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
                              child: DropdownButtonFormField<String>(
                                value: _selectedRole,
                                decoration: InputDecoration(
                                  labelText: "Select Role",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                items: ["Admin", "Publisher"]
                                    .map((role) => DropdownMenuItem(
                                          value: role,
                                          child: Text(role),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRole = value;
                                  });
                                },
                              ),
                            )
                          : Expanded(
                            child: Container(
                                width: 350,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedRole,
                                  decoration: InputDecoration(
                                    labelText: "Select Role",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  items: ["Admin", "Publisher"]
                                      .map((role) => DropdownMenuItem(
                                            value: role,
                                            child: Text(role),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRole = value;
                                    });
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
                        child: MaterialButton(
                          color: const Color.fromARGB(255, 85, 191, 218),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (_usernameController.text.trim().isNotEmpty &&
                                  _selectedRole != null) {
                                var message = await _controller.addAdmin(
                                    widget.pageId,
                                    _usernameController.text.trim(),
                                    _selectedRole!);
                                (message != null)
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomAlertDialog(
                                            title: 'Aret',
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
                          child: Text('Add Admin',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      )
                    : Expanded(
                      child: Container(
                          width: 350,
                          child: MaterialButton(
                            color: const Color.fromARGB(255, 85, 191, 218),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (_usernameController.text.trim().isNotEmpty &&
                                    _selectedRole != null) {
                                  var message = await _controller.addAdmin(
                                      widget.pageId,
                                      _usernameController.text.trim(),
                                      _selectedRole!);
                                  (message != null)
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomAlertDialog(
                                              title: 'Aret',
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
                            child: Text('Add Admin',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 17)),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
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
