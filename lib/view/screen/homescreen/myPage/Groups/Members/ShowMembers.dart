import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/Members_controller/ShowMembers_controller.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/Members/MemberType.dart';

class ShowMembers extends StatefulWidget {
 // final ShowMembersController _controller = ShowMembersController();
  final  pageId;
  final groupId;
  final localMembers;

  
ShowMembers({required this.pageId, this.localMembers, this.groupId});
  @override
  _ShowMembersState createState() => _ShowMembersState();
}

class _ShowMembersState extends State<ShowMembers> {
  final SearchControllerImp controller = Get.put(SearchControllerImp());
  late ShowMembersController _controller;
  @override
  void initState() {
    super.initState();
    _controller = ShowMembersController();
     _controller.members.addAll(widget.localMembers);
  }
  @override
  Widget build(BuildContext context) {

    if (kIsWeb) {
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
      body: Container(
        height: MediaQuery.of(context).size.height - 50,
        child: Row(
          children: [
            Expanded(flex: 3, child: Container()),
            Expanded(
              flex: 4,
              child: Container(
                 decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes the position of shadow
                      ),
                    ],
                  ),
                child: Column(
                  children: [
                    const Divider(
                      color: Color.fromARGB(255, 194, 193, 193),
                      thickness: 2.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _controller.members.length,
                        itemBuilder: (context, index) {
                          final admin = _controller.members[index];
                          final firstname = admin['firstname'];
                          final lastname = admin['lastname'];
                          final username = admin['username'];
                          
                
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  final userUsername = username;
                                   controller.goToUserPage(userUsername!);
                                },
                                leading: CircleAvatar(
                                  backgroundImage: (admin['photo'] != null &&
                                          admin['photo'] != "")
                                      ? Image.network("$urlStarter/" + admin['photo']!)
                                          .image
                                      : _controller.defaultProfileImage,
                                ),
                                title: Text('$firstname $lastname '),
                                subtitle: Text('$username'),
                                trailing:  PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (String option) async {
                                    var message = await _controller.onMoreOptionSelected(option,username,widget.groupId);
                                    (message != null)
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomAlertDialog(
                                          title: 'Alert',
                                          icon: Icons.error,
                                          text: message,
                                          buttonText: 'OK',
                                          
                                        );
                                      },
                                    )
                                  : null;
                                  setState(() {
                                    
                                  });
                                  },
                                  itemBuilder: (BuildContext context) {
                                      return _controller.moreOptions.map((String option) {
                                        return PopupMenuItem<String>(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList();
                                  },
                                ),
                              
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
              ),
            ),
            Expanded(flex: 3, child: Container()),
          ],
        ),
      ),
    );

      
    }else{
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
              itemCount: _controller.members.length,
              itemBuilder: (context, index) {
                final admin = _controller.members[index];
                final firstname = admin['firstname'];
                final lastname = admin['lastname'];
                final username = admin['username'];
                

                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        final userUsername = username;
                         controller.goToUserPage(userUsername!);
                      },
                      leading: CircleAvatar(
                        backgroundImage: (admin['photo'] != null &&
                                admin['photo'] != "")
                            ? Image.network("$urlStarter/" + admin['photo']!)
                                .image
                            : _controller.defaultProfileImage,
                      ),
                      title: Text('$firstname $lastname '),
                      subtitle: Text('$username'),
                      trailing:  PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (String option) async {
                          var message = await _controller.onMoreOptionSelected(option,username,widget.groupId);
                          (message != null)
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomAlertDialog(
                                title: 'Alert',
                                icon: Icons.error,
                                text: message,
                                buttonText: 'OK',
                                
                              );
                            },
                          )
                        : null;
                        setState(() {
                          
                        });
                        },
                        itemBuilder: (BuildContext context) {
                            return _controller.moreOptions.map((String option) {
                              return PopupMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList();
                        },
                      ),
                    
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
}