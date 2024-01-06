import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/notificationspages/showPost.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

    class JobApplicant {
  final String? image;
  final String name;
  final String username;
  final String notes;
  final String cvPath;

  JobApplicant({
    this.image,
    required this.name,
    required this.username,
    required this.notes,
    required this.cvPath,
  });
}

class JobPost {
  final String title;
  final String company;
  final String interest;
  final String? image;
  final String deadline;
  final String content;
  final List<JobApplicant> applicants;

  JobPost({
    required this.title,
    required this.company,
    required this.interest,
    this.image,
    required this.deadline,
    required this.content,
    required this.applicants,
  });
}

class ShowJobApplicantsController {

  final List<JobPost> jobPosts = [
    JobPost(
      title: "Software Engineer",
      company: "Tech Co.",
      interest: "Software Development",
      image: null,
      deadline: "2024-01-13",
      content:
          "We are looking for a skilled software engineer... We are looking for a skilled software engineer...We are looking for a skilled software engineer...We are looking for a skilled software engineer...",
      applicants: [
        JobApplicant(
          image: null,
          name: "Obaida Aws",
          username: "@obaida_aws",
          notes:
              "I'm excited about this opportunity and believe my skills in software development make me a great fit. I have experience working on various projects and am eager to contribute to your team.",
          cvPath: "cv_file_path",
        ),
      ],
    ),
  ];
  
  final List<Map<String, dynamic>> jobs = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int pageSize = 10;
  int page = 1;

  getPageJobs(int page, String pageId) async {
    
    var url =
        "$urlStarter/user/getPageJobs?page=$page&pageSize=$pageSize&pageId=$pageId";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  Future<void> loadPageJobs(page,pageId) async {
    if (isLoading) {
      return;
    }
    
    isLoading = true;
    var response = await getPageJobs(page,pageId);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadPageJobs(page,pageId);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return;
    } else if (response.statusCode == 200) {
      
      
      var responseBody = jsonDecode(response.body);
      final List<dynamic>? pageJobs = responseBody["pageJobs"];
      print(pageJobs);
      print("userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      if (pageJobs != null) {
        final newJob = pageJobs.map((job) {
          return {
            'pageJobId': job['pageJobId'],
            'pageId': job['pageId'],
            'title': job['title'],
            'interest': job['interest'],
            'description': job['description'],
            'endDate': job['endDate'],
          };
        }).toList();

        jobs.addAll(newJob);
        //print(notifications);
      }

      isLoading = false;
    }
    
    /*
    await Future.delayed(const Duration(seconds: 2), () {
    });*/
    return;
  }


  
}
