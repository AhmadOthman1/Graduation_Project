import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/JobsPage_Controller/ShowAllMyJobs_controller.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'package:growify/global.dart';

class MyJobPage extends StatefulWidget {
  const MyJobPage({Key? key}) : super(key: key);

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
      await _controller.loadNotifications(_controller.page);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundImage: (job['photo'] != null &&
                                  job['photo'] != "")
                              ? Image.network("$urlStarter/" + job['photo']!)
                                  .image
                              : defultprofileImage,
                        ),
                        title: Text(
                          "${job['notificationContent']}",
                          
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Deadline: ${job['date']}'),
                            const SizedBox(height: 8),
                            Text(job['notificationContent']),
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











/*import 'package:flutter/material.dart';


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

class MyJobPage extends StatefulWidget {
  @override
  _MyJobPageState createState() => _MyJobPageState();
}

class _MyJobPageState extends State<MyJobPage> {


  
  final List<JobPost> jobPosts = [
    JobPost(
      company: "Tech Co.",
      image: "images/harri.png",
      deadline: "March 15, 2023",
      content: "We are looking for a skilled software engineer...",
    ),
    JobPost(
      company: "Design Studio",
      image: "images/harri.png",
      deadline: "March 20, 2023",
      content: "Join our creative team as a graphic designer...",
    ),
    // Add more job posts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Posts'),
      ),
      body: ListView.builder(
        itemCount: jobPosts.length,
        itemBuilder: (context, index) {
          return JobPostCard(jobPost: jobPosts[index]);
        },
      ),
    );
  }
}

class JobPostCard extends StatelessWidget {
  final JobPost jobPost;

  JobPostCard({required this.jobPost});

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
