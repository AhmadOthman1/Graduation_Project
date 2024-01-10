import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/AdminsGroup_controller.dart/AdminsGroup_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/Admins/AddGroupAdmin.dart';

class GroupAdmins extends StatefulWidget {
  final ShowGroupAdminsController _controller = ShowGroupAdminsController();
  final  pageId;
  final groupId;
  final localAdmins;

  GroupAdmins({required this.pageId, this.localAdmins, this.groupId});

  @override
  _GroupAdminsState createState() => _GroupAdminsState();
}

class _GroupAdminsState extends State<GroupAdmins> {
  @override
  void initState() {
    super.initState();
     widget._controller.admins.addAll(widget.localAdmins);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Get.to(AddGroupAdmin(pageId: widget.pageId,groupId:widget.groupId));
            },
            child: Text(
              "Add Admin",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget._controller.admins.length,
              itemBuilder: (context, index) {
                final admin = widget._controller.admins[index];
                final firstname = admin['firstname'];
                final lastname = admin['lastname'];
                final username = admin['username'];
          

                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        final userUsername = username;
                      },
                      trailing: CircleAvatar(
                        backgroundImage: (admin['photo'] != null &&
                                admin['photo'] != "")
                            ? Image.network("$urlStarter/" + admin['photo']!)
                                .image
                            : widget._controller.defaultProfileImage,
                      ),
                      title: Text('$firstname $lastname '),
                      subtitle: Text('$username'),
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 194, 193, 193),
                      thickness: 2.0,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}