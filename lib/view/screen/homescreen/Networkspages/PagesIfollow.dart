import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/controller/home/network_controller/showcolleagues_controller.dart';
import 'package:growify/controller/home/network_controller/showpagesiFollow_controller.dart';
import 'package:growify/global.dart';

class ShowPagesIFollow extends StatefulWidget {
  const ShowPagesIFollow({Key? key}) : super(key: key);

  @override
  _ShowPagesIFollowState createState() => _ShowPagesIFollowState();
}

final ScrollController scrollController = ScrollController();

class _ShowPagesIFollowState extends State<ShowPagesIFollow> {
  final NetworkMainPageControllerImp Networkcontroller = Get.put(NetworkMainPageControllerImp());
  late ShowPagesIFollowController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  

  @override
  void initState() {
    super.initState();
    _controller = ShowPagesIFollowController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadPages(_controller.page);
      setState(() {
        _controller.page++;
        _controller.PagesIfollow;
      });
      print('Data loaded: ${_controller.PagesIfollow.length} Pages');
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
        title: const Text('Pages I Follow'),
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
              itemCount: _controller.PagesIfollow.length,
              itemBuilder: (context, index) {
                final pageFollowed = _controller.PagesIfollow[index];
                final firstname=pageFollowed['name'];
                
                
                
                return Column(
                  children: [
                    ListTile(
                      onTap: (){
                       final pageId =pageFollowed['id'];
                        Networkcontroller.goToPage(pageId!);
                        
                      },
                      leading: CircleAvatar(
                        backgroundImage: (pageFollowed['photo'] != null &&
                                pageFollowed['photo'] != "")
                            ? Image.network("$urlStarter/" + pageFollowed['photo']!)
                                .image
                            : defultprofileImage,
                      ),
                      title: Text('$firstname ',style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),),
                      
                      
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
