import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/myPage_Controller/JobsPage_Controller/ShowAllMyJobs_controller.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/JobsPages/ShowJobApplicants.dart';
import 'package:growify/view/screen/homescreen/myPage/JobsPages/addnewjob.dart';

class MyJobPage extends StatefulWidget {
  final pageId;
  final pageName;
  final pagePhoto;

  const MyJobPage(
      {Key? key,
      required this.pageId,
      required this.pageName,
      required this.pagePhoto})
      : super(key: key);

  @override
  _MyJobPageState createState() => _MyJobPageState();
}

final ScrollController scrollController = ScrollController();

class _MyJobPageState extends State<MyJobPage> {
  late MyJobController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  final SearchControllerImp searchController = Get.put(SearchControllerImp());

  @override
  void initState() {
    super.initState();
    _controller = MyJobController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadPageJobs(_controller.page, widget.pageId);
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
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Jobs'),
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

                            return InkWell(
                              onTap: () {
                                Get.to(ShowJobApplicants(
                                    pageJobId: job['pageJobId'],
                                    pageId: widget.pageId,
                                    pageName: widget.pageName,
                                    pagePhoto: widget.pagePhoto));
                              },
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                              ),
                            );
                          },
                        ),
                      ),
                      if (_controller.isLoading)
                        const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              Expanded(flex: 3, child: Container()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _controller.getFields(widget.pageId,context);
          },
          tooltip: 'Add Job',
          child: Icon(Icons.post_add_outlined),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Jobs'),
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

                  return InkWell(
                    onTap: () {
                      Get.to(ShowJobApplicants(
                          pageJobId: job['pageJobId'],
                          pageId: widget.pageId,
                          pageName: widget.pageName,
                          pagePhoto: widget.pagePhoto));
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
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
                    ),
                  );
                },
              ),
            ),
            if (_controller.isLoading) const CircularProgressIndicator(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _controller.getFields(widget.pageId,context);
          },
          tooltip: 'Add Job',
          child: Icon(Icons.post_add_outlined),
        ),
      );
    }
  }
}
