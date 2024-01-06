import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/AdminsGroup_controller.dart/AdminsGroup_controller.dart';
import 'package:growify/controller/home/Groups_controller/Members_controller/SHowMembers_controller.dart';
import 'package:growify/controller/home/myPage_Controller/Admin_controller/ShowAdmin_controller.dart';
import 'package:growify/controller/home/myPage_Controller/Employee_Controller/ShowEmployee_controller.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/Groups/Admins/AddGroupAdmin.dart';
import 'package:growify/view/screen/homescreen/myPage/Admins/SelectAdmin.dart';
import 'package:growify/view/screen/homescreen/myPage/Employees/addEmployee.dart';

class GroupAdmins extends StatefulWidget {
  final pageId;
  const GroupAdmins({Key? key , required this.pageId}) : super(key: key);

  @override
  _GroupAdminsState createState() => _GroupAdminsState();
}

final ScrollController scrollController = ScrollController();

class _GroupAdminsState extends State<GroupAdmins> {
  final NetworkMainPageControllerImp Networkcontroller = Get.put(NetworkMainPageControllerImp());
  late ShowGroupAdminsController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  

  @override
  void initState() {
    super.initState();
    _controller = ShowGroupAdminsController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadAdmins(_controller.page,widget.pageId);
      setState(() {
        _controller.page++;
        _controller.admins;
      });
      print('Data loaded: ${_controller.admins.length} admins');
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadData();
    }
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  
  actions: [
    TextButton(
      
      onPressed: () {
      
       Get.off(AddGroupAdmin(pageId:widget.pageId));
      },
      child: Text("Add Admin",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
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
              controller: _scrollController,
              itemCount: _controller.admins.length,
              itemBuilder: (context, index) {
                final admin = _controller.admins[index];
                final firstname=admin['firstname'];
                final lastname =admin['lastname'];
                final username =admin['username'];
                final adminType =admin['adminType'];
                
                return Column(
                  children: [
                    ListTile(
                      onTap: (){
                        final userUsername = username;
                              Networkcontroller.goToUserPage(userUsername!);
                        
                      },
                      trailing: CircleAvatar(
                        backgroundImage: (admin['photo'] != null &&
                                admin['photo'] != "")
                            ? Image.network("$urlStarter/" + admin['photo']!)
                                .image
                            : defultprofileImage,
                      ),
                      title: Text('$firstname $lastname ($adminType)'),
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
          if (_controller.isLoading) const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
