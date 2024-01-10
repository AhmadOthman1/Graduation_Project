import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/Members_controller/ShowMembers_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/Members/MemberType.dart';

class ShowMembers extends StatefulWidget {
  final ShowMembersController _controller = ShowMembersController();
  final  pageId;
  final groupId;
  final localMembers;

  
ShowMembers({required this.pageId, this.localMembers, this.groupId});
  @override
  _ShowMembersState createState() => _ShowMembersState();
}

class _ShowMembersState extends State<ShowMembers> {
  @override
  void initState() {
    super.initState();
     widget._controller.members.addAll(widget.localMembers);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Get.to(MemberType(pageId: widget.pageId,groupId:widget.groupId));
            },
            child: Text(
              "Add Member",
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
              itemCount: widget._controller.members.length,
              itemBuilder: (context, index) {
                final admin = widget._controller.members[index];
                final firstname = admin['firstname'];
                final lastname = admin['lastname'];
                final username = admin['username'];
                final memberType = admin['memberType'];

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
                      title: Text('$firstname $lastname ($memberType)'),
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