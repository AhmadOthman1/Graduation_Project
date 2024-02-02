import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/myPage_Controller/JobsPage_Controller/ShowAllMyJobs_controller.dart';
import 'package:growify/controller/home/myPage_Controller/JobsPage_Controller/companyJob_controller.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/JobsPages/showthejob.dart';

class CompanyJobPage extends StatefulWidget {
  final pageId;
  final image;
  const CompanyJobPage({Key? key , required this.pageId, required this.image}) : super(key: key);

  @override
  _CompanyJobPageState createState() => _CompanyJobPageState();
}

final ScrollController scrollController = ScrollController();

class _CompanyJobPageState extends State<CompanyJobPage> {
  late CompanyJobController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  final SearchControllerImp searchController = Get.put(SearchControllerImp());

  @override
  void initState() {
    super.initState();
    _controller = CompanyJobController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadJobs(_controller.page, widget.pageId);
      setState(() {
        _controller.page++;
        _controller.jobs;
      });
      print('Data loaded: ${_controller.jobs.length} jobs');
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // reached the bottom, load more notifications
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
   if(kIsWeb){
     return Scaffold(
      appBar: AppBar(
        title: const Text('All Jobs'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 100,
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
                        controller: _scrollController,
                        itemCount: _controller.jobs.length,
                        itemBuilder: (context, index) {
                          final job = _controller.jobs[index];
                
                          return Card(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.open_in_new),
                                      onPressed: () {
                                        Get.to(ShowTheJob(jopId: job['pageJobId'],title:job['title'],company:widget.pageId,Fields: job['Fields'], image:widget.image,deadline:job['endDate'],content:job['description']));
                                      },
                                    ),
                                  ],
                                ),
                                    title: Text(
                                      "${job['title']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Fields: ${job['Fields']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          job['description'],
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Deadline: ${job['endDate']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                         
                        },
                      ),
                    ),
                    if (_controller.isLoading) const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
            Expanded(flex: 3, child: Container()),
          ],
        ),
      ),
    );

   }
   
   
   else{
     return Scaffold(
      appBar: AppBar(
        title: const Text('All Jobs'),
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
              itemCount: _controller.jobs.length,
              itemBuilder: (context, index) {
                final job = _controller.jobs[index];

                return Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: () {
                              Get.to(ShowTheJob(jopId: job['pageJobId'],title:job['title'],company:widget.pageId,Fields: job['Fields'], image:widget.image,deadline:job['endDate'],content:job['description']));
                            },
                          ),
                        ],
                      ),
                          title: Text(
                            "${job['title']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fields: ${job['Fields']}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Deadline: ${job['endDate']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
}











