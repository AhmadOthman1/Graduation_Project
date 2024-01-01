import 'package:flutter/material.dart';


class AddAdmin extends StatefulWidget {
  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  TextEditingController _usernameController = TextEditingController();
  List<String> admins = ['admin1', 'admin2', 'admin3'];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void _addAdmin() {

    String newAdmin = _usernameController.text.trim();
if (formKey.currentState!.validate()) {
    if (newAdmin.isNotEmpty) {
      if (!admins.contains(newAdmin)) {
        // Username doesn't exist, show a popup
        _showUsernameNotExistPopup();
      } else {
        
        admins.add(newAdmin);
        _usernameController.clear();
        
        print('Admin added: $newAdmin');
      }
    }}
  }

  void _showUsernameNotExistPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Username Not Exists'),
          content: Text('The entered username does not exist.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      //  title: Text('Add New Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        //  mainAxisAlignment: MainAxisAlignment.,
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
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: "Enter Username",
                  hintStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 30),
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Username';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addAdmin,
              child: Text('Add Admin'),
            ),
          ],
        ),
      ),
    );
  }
}