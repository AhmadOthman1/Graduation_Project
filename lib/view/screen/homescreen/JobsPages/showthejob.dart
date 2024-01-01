import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:growify/controller/home/JobsPage_Controller/ShowTheJob_controller.dart';

class JobPost {
  final String company;
  final String image;
  final String deadline;
  final String content;

  JobPost({
    required this.company,
    required this.image,
    required this.deadline,
    required this.content,
  });
}

class ShowTheJob extends StatefulWidget {
  @override
  _ShowTheJobState createState() => _ShowTheJobState();
}

class _ShowTheJobState extends State<ShowTheJob> {
  
  final List<JobPost> jobPosts = [
    JobPost(
      company: "Tech Co.",
      image: "images/harri.png",
      deadline: "2024-01-13",
      content:
          "We are looking for a skilled software engineer... We are looking for a skilled software engineer...We are looking for a skilled software engineer...We are looking for a skilled software engineer...",
    ),
  ];
 

  @override
  Widget build(BuildContext context) {
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
  JobPostCard({required this.jobPost});
  final ShowTheJobImp Controller22 = Get.put(ShowTheJobImp());

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
              backgroundImage: AssetImage(jobPost.image),
            ),
            title: Text(jobPost.company),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deadline: ${jobPost.deadline}'),
                SizedBox(height: 8),
                Text(jobPost.content),
                SizedBox(height: 16),
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
                        return 'Please enter an notice ';
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
                            final result = await FilePicker.platform.pickFiles(
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
                              
                              onPressed: () {
                                   String notice = noticeController.text;
                                // Process the notice as needed
                                if (formKey.currentState!.validate()) {
                                  print('Notice: $notice');
                                  Controller22.SaveChange(cvBytes, cvName, cvExt,notice);

                                  
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
