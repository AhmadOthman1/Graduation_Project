import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/createGroup_controller.dart';

class CreateGroupPage extends StatefulWidget {
  final groupsData;
  final pageId;
  const CreateGroupPage(
      {Key? key, required this.groupsData, required this.pageId})
      : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  TextEditingController _groupNameController = TextEditingController();
  String? _selectedParentNode;
  TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late CreateGroupsController groupsController;

  late List<String> defaultParentNodes;

  @override
  void initState() {
    super.initState();
    groupsController = CreateGroupsController(groupsData: widget.groupsData);
    defaultParentNodes = groupsController.parentGroupNames;
  }

  void _createGroup() {
    if (formKey.currentState!.validate()) {
      String groupName = _groupNameController.text.trim();
      String description = _descriptionController.text.trim();

      Map<String, dynamic> newGroup = {
        'name': groupName,
        'parentNode': (_selectedParentNode != null)
            ? groupsController.findGroupByName(_selectedParentNode!) ?? null
            : null,
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
                                controller: _groupNameController,
                                decoration: InputDecoration(
                                  hintText: "Enter Group Name",
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 30),
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
                            )
                          : Expanded(
                            child: Container(
                                width: 350,
                                child: TextFormField(
                                  controller: _groupNameController,
                                  decoration: InputDecoration(
                                    hintText: "Enter Group Name",
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 30),
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
                              child: TextFormField(
                                controller: _descriptionController,
                                maxLines: 6,
                                decoration: InputDecoration(
                                  hintText: "Enter Your Group description",
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 30),
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
                            )
                          : Expanded(
                            child: Container(
                                width: 350,
                                child: TextFormField(
                                  controller: _descriptionController,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    hintText: "Enter Your Group description",
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 30),
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
                                value: _selectedParentNode,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedParentNode = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "All groups",
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: "Parent Group",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                items:
                                    defaultParentNodes.map((String parentNode) {
                                  return DropdownMenuItem<String>(
                                    value: parentNode,
                                    child: Text(parentNode),
                                  );
                                }).toList(),
                              ),
                            )
                          : Expanded(
                            child: Container(
                                width: 350,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedParentNode,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedParentNode = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "All groups",
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: "Parent Group",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  items:
                                      defaultParentNodes.map((String parentNode) {
                                    return DropdownMenuItem<String>(
                                      value: parentNode,
                                      child: Text(parentNode),
                                    );
                                  }).toList(),
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
                              onPressed: _createGroup,
                              child: Text(
                                'Create',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                           
                        ),
                      )
                    : Expanded(
                       
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 350,
                            child: MaterialButton(
                              color: const Color.fromARGB(255, 85, 191, 218),
                              onPressed: _createGroup,
                              child: Text(
                                'Create',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
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
