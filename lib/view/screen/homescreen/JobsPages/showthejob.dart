import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:growify/controller/home/myPage_Controller/JobsPage_Controller/ShowTheJob_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/global.dart';

class JobPost {
  final String title;
  final String company;
  final String Fields;
  final String? image; // Change the type to String?
  final String deadline;
  final String content;
  final jobId;
  JobPost({
    required this.title,
    required this.company,
    required this.Fields,
    this.image, // Update the type to String?
    required this.deadline,
    required this.content,
    required this.jobId,
  });
}


class ShowTheJob extends StatefulWidget {
final String title;
  final String company;
  final String Fields;
  final String? image; // Change the type to String?
  final String deadline;
  final String content;
  final jopId;
    const ShowTheJob({Key? key , required this.title,
    required this.company,
    required this.Fields,
    this.image, // Update the type to String?
    required this.deadline,
    required this.content,required this.jopId}) : super(key: key);

  @override
  _ShowTheJobState createState() => _ShowTheJobState();
}

class _ShowTheJobState extends State<ShowTheJob> {
  
 



  @override
  Widget build(BuildContext context) {
    final List<JobPost> jobPosts = [
    JobPost(
      title: widget.title,
      company: widget.company,
      Fields: widget.Fields,
      image: widget.image,
      deadline: widget.deadline,
      content:widget.content,
      jobId: widget.jopId,
    ),
  ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Post'),
      ),
      body: SingleChildScrollView(
        child: JobPostCard(jobPost: jobPosts[0]),
      ),
    );
  }
}

class JobPostCard extends StatelessWidget {
  final JobPost jobPost;
  String? cvBytes;
  String? cvName;
  String? cvExt;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ShowTheJobImp Controller22 = Get.put(ShowTheJobImp());
  final AssetImage defaultProfileImage =
      const AssetImage("images/profileImage.jpg");

  JobPostCard({required this.jobPost});

  @override
  Widget build(BuildContext context) {
    DateTime deadlineDate = DateTime.parse(jobPost.deadline);
    bool isBeforeDeadline = DateTime.now().isBefore(deadlineDate);

    TextEditingController noticeController = TextEditingController();

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
                Text('Fields: ${jobPost.Fields}'),
                SizedBox(height: 8),
                Text(jobPost.content),
                SizedBox(height: 16),
                Text('Deadline: ${jobPost.deadline}'),
                // Display the text field if before the deadline
                if (isBeforeDeadline)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter your notice:'),
                      SizedBox(height: 8),
                      Form(
                        key: formKey,
                        child: TextFormField(
                          maxLines: 5,
                          controller: noticeController,
                          decoration: InputDecoration(
                            hintText: "Type your notice here...",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a notice ';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () async {
                                final result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                  allowMultiple: false,
                                );

                                if (result != null && result.files.isNotEmpty) {
                                  PlatformFile file = result.files.first;
                                  if (file.extension == "pdf") {
                                    String base64String;
                                    if (kIsWeb) {
                                      final fileBytes = file.bytes;
                                      base64String =
                                          base64Encode(fileBytes as List<int>);
                                    } else {
                                      List<int> fileBytes =
                                          await File(file.path!).readAsBytes();
                                      base64String = base64Encode(fileBytes);
                                    }
                                    cvBytes = base64String;
                                    cvName = file.name;
                                    cvExt = file.extension;
                                  } else {
                                    cvBytes = null;
                                    cvName = null;
                                    cvExt = null;
                                  }
                                } else {
                                  // User canceled the picker
                                  cvBytes = null;
                                  cvName = null;
                                  cvExt = null;
                                }
                              },
                              child: Text('Upload CV'),
                            ),
                          ),
                          Container(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () async {
                                String notice = noticeController.text;
                                // Process the notice as needed
                                if (formKey.currentState!.validate()) {
                                  print('Title: ${jobPost.title}');
                                  print('Fields: ${jobPost.Fields}');
                                  print('Company: ${jobPost.company}');
                                  print('Notice: $notice');
                                  print('Selected CV: $cvName');
                                  var message = await Controller22.SaveApplication(
                                      cvBytes, cvName, cvExt, notice,jobPost.jobId);
                                      (message != null)
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomAlertDialog(
                                      title: 'Message',
                                      icon: Icons.error,
                                      text: message,
                                      buttonText: 'OK',
                                    );
                                  },
                                )
                              : null;
                                }
                              },
                              child: Text('Apply'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
