import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Admin_controller/ShowAdmin_controller.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/Admins/SelectAdmin.dart';

class ShowAdmins extends StatefulWidget {
  const ShowAdmins({Key? key}) : super(key: key);

  @override
  _ShowAdminsState createState() => _ShowAdminsState();
}

final ScrollController scrollController = ScrollController();

class _ShowAdminsState extends State<ShowAdmins> {
  final NetworkMainPageControllerImp Networkcontroller = Get.put(NetworkMainPageControllerImp());
  late ShowAdminsController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  

  @override
  void initState() {
    super.initState();
    _controller = ShowAdminsController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadNotifications(_controller.page);
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
       Get.to(AddAdmin());
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
                      title: Text('$firstname $lastname'),
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
