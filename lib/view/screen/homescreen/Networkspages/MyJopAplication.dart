import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/myPage_Controller/JobsPage_Controller/ShowAllMyJobs_controller.dart';
import 'package:growify/controller/home/myPage_Controller/JobsPage_Controller/companyJob_controller.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'package:growify/controller/home/network_controller/MyJobApplication_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/services/notification_service.dart';
import 'package:growify/view/screen/homescreen/myPage/JobsPages/showthejob.dart';
import 'dart:io';

class MyJopApllication extends StatefulWidget {
  const MyJopApllication({Key? key}) : super(key: key);

  @override
  _MyJopApllicationState createState() => _MyJopApllicationState();
}

final ScrollController scrollController = ScrollController();

class _MyJopApllicationState extends State<MyJopApllication> {
  late MyJobApplicationController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  final SearchControllerImp searchController = Get.put(SearchControllerImp());

  @override
  void initState() {
    super.initState();
    _controller = MyJobApplicationController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadJobs(_controller.page);
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
          title: const Text('My Jobs Applications'),
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
                                      children: [],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          job['description'],
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
                                          'Fields: ${job['Fields']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          'Company: ${job['pageId']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Note: ${job['note']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Visibility(
                                          visible: job['cv'] != null,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              download(urlStarter, job['cv']);

                                              Navigator.pop(context);
                                            },
                                            child: Text('Download CV'),
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
      );
    } else {
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
                            children: [],
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
                                job['description'],
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
                                'Fields: ${job['Fields']}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Company: ${job['pageId']}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Note: ${job['note']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 16),
                              Visibility(
                                visible: job['cv'] != null,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    download(urlStarter, job['cv']);

                                    Navigator.pop(context);
                                  },
                                  child: Text('Download CV'),
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

Future download(String url, String filename) async {
  print(url);
  print(filename);
  if (kIsWeb) {
    try {
      FileSaver.instance.saveFile(
          name: filename.split('.')[0],
          link: LinkDetails(link: url + "/" + filename),
          ext: 'pdf',
          mimeType: MimeType.pdf);
    } catch (err) {
      print(err);
    }
  } else {
    var savePath = '/storage/emulated/0/Download/$filename';
    var dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      var response = await dio.get(
        url + "/" + filename,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      var file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      var playSound = true;
      Duration timeoutAfter = Duration(seconds: 5);
      await NotificationService.initializeNotification(playSound);
      await NotificationService.showNotification(
        title: "Growify",
        body: "file $filename downloaded successfully",
        chronometer: Duration.zero,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
