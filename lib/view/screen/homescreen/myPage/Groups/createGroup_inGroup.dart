import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/createGroup_inGroup_controller.dart';

class CreateGroupinGroupPage extends StatefulWidget {
  final groupsData;
  final pageId;
  const CreateGroupinGroupPage({Key? key, required this.groupsData, required this.pageId}) : super(key: key);

  @override
  _CreateGroupinGroupPageState createState() => _CreateGroupinGroupPageState();
}

class _CreateGroupinGroupPageState extends State<CreateGroupinGroupPage> {
  TextEditingController _groupNameController = TextEditingController();
  String? _selectedParentNode;
  TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late CreateGroupsinGroupController groupsController;

  late List<String> defaultParentNodes;

  @override
  void initState() {
    super.initState();
    groupsController = CreateGroupsinGroupController();
    
  }

  void _createGroup() {
    if (formKey.currentState!.validate()) {
      String groupName = _groupNameController.text.trim();
      String description = _descriptionController.text.trim();

      Map<String, dynamic> newGroup = {
        'name': groupName,
        'parentNode': widget.groupsData['id'],
            
        'description': description,
        'pageId': widget.pageId,
      };

      groupsController.addGroup(newGroup);

      _groupNameController.clear();
      _descriptionController.clear();
      _selectedParentNode = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Group',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  
                  TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      hintText: "Enter Group Name",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      labelText: "Group Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Group Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Enter Your Group description",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Group Name';
                      }
                      return null;
                    },
                  ),
                 
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 380,
                  child: MaterialButton(
                    color: const Color.fromARGB(255, 85, 191, 218),
                    onPressed: _createGroup,
                    child: Text(
                      'Create',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}