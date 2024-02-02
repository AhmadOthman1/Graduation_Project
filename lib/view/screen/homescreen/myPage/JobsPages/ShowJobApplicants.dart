import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'package:growify/controller/home/myPage_Controller/JobsPage_Controller/ShowJobApplicants_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/chat/pageChatpagemessages.dart';
import 'package:growify/view/screen/homescreen/taskes/tasksmainpage.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowJobApplicants extends StatefulWidget {
  final pageJobId;
  final pageId;
  final pageName;
  final pagePhoto;
  const ShowJobApplicants(
      {Key? key,
      required this.pageJobId,
      required this.pageId,
      required this.pageName,
      required this.pagePhoto})
      : super(key: key);

  @override
  _ShowJobApplicantsState createState() => _ShowJobApplicantsState();
}

class _ShowJobApplicantsState extends State<ShowJobApplicants> {
  late ShowJobApplicantsController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defaultProfileImage =
      const AssetImage("images/profileImage.jpg");
  final SearchControllerImp searchController = Get.put(SearchControllerImp());

  @override
  void initState() {
    super.initState();
    _controller = ShowJobApplicantsController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadPageJobs(widget.pageJobId);
      setState(() {
        _controller.page++;
      });
      // print('Data loaded: ${_controller.jobs.length} jobs');
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

  Future download(String url, String filename) async {
    var savePath = '/storage/emulated/0/Download/$filename';
    var dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      var response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      var file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
   if(kIsWeb){
     return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _controller.jobPosts.length,
                        itemBuilder: (context, index) {
                          return JobPostCard(jobPost: _controller.jobPosts[index]);
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Applicants:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      ..._controller.Aqraba.map((applicant) {
                        return ListTile(
                            leading: InkWell(
                              onTap: () {
                                _controller.goToUserPage(applicant['user']['username']);
                              },
                              child: CircleAvatar(
                                backgroundImage: (applicant['user']['photo'] != null)
                                    ? Image.network(
                                            "${urlStarter}/${applicant['user']['photo']}")
                                        .image
                                    : defaultProfileImage,
                              ),
                            ),
                            title: Text(
                                "${applicant['user']['firstname']} ${applicant['user']['lastname']}"),
                            subtitle: Text("@${applicant['user']['username']}"),
                            trailing: Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    var pageAccessToken = await _controller
                                        .generatePageAccessToken(widget.pageId);
                                    final Map<String, dynamic> userInfo = {
                                      'name':
                                          "${applicant['user']['firstname']} ${applicant['user']['lastname']}",
                                      'username': "${applicant['user']['username']}",
                                      'photo': "${applicant['user']['photo']}",
                                      'type': "U",
                                    };
                                    Get.to(pageChatpagemessages(
                                        data: userInfo,
                                        pageId: widget.pageId,
                                        pageName: widget.pageName,
                                        pagePhoto: widget.pagePhoto,
                                        pageAccessToken: pageAccessToken));
                                  },
                                  child: Icon(Icons.message),
                                ),
                                InkWell(
                                  onTap: () {
                                    _showApplicantDetails(context, applicant);
                                  },
                                  child: Icon(Icons.assignment_outlined),
                                ),
                              ],
                            ));
                      }).toList(),
                    ],
                  ),
                ),
              ),
               Expanded(flex: 3, child: Container()),
            ],
          ),
        ),
      ),
    );
    
   }else{
     return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: _controller.jobPosts.length,
              itemBuilder: (context, index) {
                return JobPostCard(jobPost: _controller.jobPosts[index]);
              },
            ),
            SizedBox(height: 16),
            Text(
              'Applicants:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ..._controller.Aqraba.map((applicant) {
              return ListTile(
                  leading: InkWell(
                    onTap: () {
                      _controller.goToUserPage(applicant['user']['username']);
                    },
                    child: CircleAvatar(
                      backgroundImage: (applicant['user']['photo'] != null)
                          ? Image.network(
                                  "${urlStarter}/${applicant['user']['photo']}")
                              .image
                          : defaultProfileImage,
                    ),
                  ),
                  title: Text(
                      "${applicant['user']['firstname']} ${applicant['user']['lastname']}"),
                  subtitle: Text("@${applicant['user']['username']}"),
                  trailing: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          var pageAccessToken = await _controller
                              .generatePageAccessToken(widget.pageId);
                          final Map<String, dynamic> userInfo = {
                            'name':
                                "${applicant['user']['firstname']} ${applicant['user']['lastname']}",
                            'username': "${applicant['user']['username']}",
                            'photo': "${applicant['user']['photo']}",
                            'type': "U",
                          };
                          Get.to(pageChatpagemessages(
                              data: userInfo,
                              pageId: widget.pageId,
                              pageName: widget.pageName,
                              pagePhoto: widget.pagePhoto,
                              pageAccessToken: pageAccessToken));
                        },
                        child: Icon(Icons.message),
                      ),
                      InkWell(
                        onTap: () {
                          _showApplicantDetails(context, applicant);
                        },
                        child: Icon(Icons.assignment_outlined),
                      ),
                    ],
                  ));
            }).toList(),
          ],
        ),
      ),
    );
   }
  }

  _showApplicantDetails(BuildContext context, dynamic applicant) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: InkWell(
                    onTap: () {
                      _controller.goToUserPage(applicant['user']['username']);
                    },
                    child: CircleAvatar(
                      backgroundImage: (applicant['user']['photo'] != null)
                          ? Image.network(
                                  "${urlStarter}/${applicant['user']['photo']}")
                              .image
                          : defaultProfileImage,
                    ),
                  ),
                  title: Text(
                    "${applicant['user']['firstname']} ${applicant['user']['lastname']}",
                  ),
                  subtitle: Text("@${applicant['user']['username']}"),
                ),
                SizedBox(height: 16),
                Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                ExpansionTile(
                  title: Text('Expand to view notes'),
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          applicant['note'] ?? 'No notes available',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Visibility(
                  visible: applicant['cv'] != null,
                  child: ElevatedButton(
                    onPressed: () async {
                      var cvUrl = "$urlStarter/${applicant['cv']}";

                      if (kIsWeb) {
                        if (await canLaunch(cvUrl)) {
                          await launch(
                            cvUrl,
                            headers: {
                              "Content-Type": "application/pdf",
                              "Content-Disposition": "inline"
                            },
                          );
                        } else {
                          throw "Could not launch $cvUrl";
                        }
                      } else {
                        download(cvUrl, applicant['cv']);
                      }

                      Navigator.pop(context);
                    },
                    child: Text('Download CV'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class JobPostCard extends StatelessWidget {
  final JobPost jobPost;
  final AssetImage defaultProfileImage =
      const AssetImage("images/profileImage.jpg");

  JobPostCard({required this.jobPost});

  @override
  Widget build(BuildContext context) {
    DateTime deadlineDate = DateTime.parse(jobPost.deadline);

    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              jobPost.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fields: ${jobPost.Fields}'),
                SizedBox(height: 8),
                Text(jobPost.description),
                SizedBox(height: 16),
                Text('Deadline: ${jobPost.deadline}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
