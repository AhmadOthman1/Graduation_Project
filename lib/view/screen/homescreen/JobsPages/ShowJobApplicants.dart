import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'package:growify/controller/home/myPage_Controller/JobsPage_Controller/ShowJobApplicants_controller.dart';
import 'package:growify/global.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowJobApplicants extends StatefulWidget {
  @override
  _ShowJobApplicantsState createState() => _ShowJobApplicantsState();
}

class _ShowJobApplicantsState extends State<ShowJobApplicants> {
  late ShowJobApplicantsController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defaultProfileImage = const AssetImage("images/profileImage.jpg");
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
      await _controller.loadPageJobs(_controller.page, 1);
      setState(() {
        _controller.page++;
        // _controller.jobs; // This line doesn't seem to do anything, so I commented it out
      });
      print('Data loaded: ${_controller.jobs.length} jobs');
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
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

  // get data from data base instead of this list

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use ListView.builder to display all job posts dynamically
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
            ..._controller.jobPosts[0].applicants.map((applicant) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: (applicant.image != null && applicant.image != "")
                      ? Image.network("$urlStarter/${applicant.image}").image
                      : defaultProfileImage,
                ),
                title: Text(applicant.name),
                subtitle: Text(applicant.username),
                trailing: InkWell(
                  onTap: () {
                    _showApplicantDetails(context, applicant);
                  },
                  child: Text(
                    "More Details",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                onTap: () {
                  // go to his profile
                },
              );
            }).toList(),
            if (_controller.isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  void _showApplicantDetails(BuildContext context, JobApplicant applicant) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: (applicant.image != null && applicant.image != "")
                      ? Image.network("$urlStarter/${applicant.image}").image
                      : defaultProfileImage,
                ),
                title: Text(applicant.name),
                subtitle: Text(applicant.username),
              ),
              SizedBox(height: 16),
              Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ExpansionTile(
                title: Text('Expand to view notes'),
                children: [
                  Text(
                    applicant.notes,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  var cvUrl = "$urlStarter/${applicant.cvPath}";

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
                    download(cvUrl, applicant.cvPath);
                  }

                  Navigator.pop(context); // Close the modal bottom sheet
                },
                child: Text('Download CV'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class JobPostCard extends StatelessWidget {
  final JobPost jobPost;
  final AssetImage defaultProfileImage = const AssetImage("images/profileImage.jpg");

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
            leading: CircleAvatar(
              backgroundImage: (jobPost.image != null && jobPost.image != "")
                  ? Image.network("$urlStarter/${jobPost.image}").image
                  : defaultProfileImage,
            ),
            title: Text(jobPost.company),
            subtitle: Text(jobPost.title),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Interest: ${jobPost.interest}'),
                SizedBox(height: 8),
                Text(jobPost.content),
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
