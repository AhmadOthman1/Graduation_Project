import 'package:flutter/material.dart';
import 'package:growify/controller/home/Groups_controller/groups_controller.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  TextEditingController _groupNameController = TextEditingController();
  String? _selectedParentNode;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late GroupsController groupsController;

  late List<String> defaultParentNodes;

  @override
  void initState() {
    super.initState();
    groupsController = GroupsController();
    defaultParentNodes = groupsController.parentGroupNames;
  }

  void _createGroup() {
    if (formKey.currentState!.validate()) {
      String groupName = _groupNameController.text.trim();

      Group newGroup = Group(
        name: groupName,
        imagePath: null,
      );

      if (_selectedParentNode != null) {
        Group? parentGroup = groupsController.findGroupByName(_selectedParentNode!);

        if (parentGroup != null) {
          groupsController.addSubgroup(parentGroup, newGroup);
        } else {
          print("Parent node not found: $_selectedParentNode");
        }
      } else {
        groupsController.groups.add(newGroup);
      }

      _groupNameController.clear();
      _selectedParentNode = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Create Group',
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
                  TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      hintText: "Enter Group Name",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedParentNode,
                    onChanged: (value) {
                      setState(() {
                        _selectedParentNode = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: defaultParentNodes.isNotEmpty ? defaultParentNodes[0] : "", // Set the hintText dynamically
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Parent Node",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    items: defaultParentNodes.map((String parentNode) {
                      return DropdownMenuItem<String>(
                        value: parentNode,
                        child: Text(parentNode),
                      );
                    }).toList(),
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
                  child: ElevatedButton(
                    onPressed: _createGroup,
                    child: Text('Create'),
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
