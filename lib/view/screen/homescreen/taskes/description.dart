import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/chat/chatForWeb/chatWebmainpage.dart';
import 'package:growify/view/screen/homescreen/taskes/tasksmainpage.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'task.dart';

class DescriptionPage extends StatefulWidget {
  final Task task;

  DescriptionPage({super.key, required this.task});
  _DescriptionPageState createState() => _DescriptionPageState();
}

String _formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

late HomePageControllerImp HPcontroller = Get.put(HomePageControllerImp());
ImageProvider<Object> avatarImage = const AssetImage("images/profileImage.jpg");
String name =
    GetStorage().read("firstname") + " " + GetStorage().read("lastname");
final LogOutButtonControllerImp logoutController =
    Get.put(LogOutButtonControllerImp());

class _DescriptionPageState extends State<DescriptionPage> {
  @override
  void initState() {
    // TODO: implement initState
    updateAvatarImage();
    super.initState();
  }

  void updateAvatarImage() {
    String profileImage = GetStorage().read("photo") ?? "";
    setState(() {
      avatarImage = (profileImage.isNotEmpty)
          ? Image.network("$urlStarter/$profileImage").image
          : const AssetImage("images/profileImage.jpg");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Task Details'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Color.fromARGB(0, 255, 251, 254),
                child: InkWell(
                  onTap: () {
                    HPcontroller.goToprofilepage();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage: avatarImage,
                        ),
                        accountName: Text(
                          name ?? "",
                          style: const TextStyle(color: Colors.black),
                        ),
                        accountEmail: const Text(
                          "View profile",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ListTile(
                        title: const Text("Settings"),
                        leading: const Icon(Icons.settings),
                        onTap: () {
                          HPcontroller.goToSettingsPgae();
                        },
                      ),
                      ListTile(
                        title: const Text("Calender"),
                        leading: const Icon(Icons.calendar_today_rounded),
                        onTap: () {
                          HPcontroller.goToCalenderPage();
                        },
                      ),
                      ListTile(
                        title: const Text("Tasks"),
                        leading: const Icon(Icons.task),
                        onTap: () {
                          Get.to(const TasksHomePage());
                        },
                      ),
                      ListTile(
                        title: const Text("My Pages"),
                        leading: const Icon(Icons.contact_page),
                        onTap: () {
                          HPcontroller.goToMyPages();
                        },
                      ),
                      ListTile(
                        title: const Text("Log Out"),
                        leading: const Icon(Icons.logout_outlined),
                        onTap: () async {
                          await logoutController.goTosigninpage();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.task.taskName}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(
                          left: 8.0), // Adjust the padding as needed
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.grey, // Set your desired border color
                            width: 2.0, // Set your desired border width
                          ),
                        ),
                      ),
                      child: Text(
                        '${widget.task.description}',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Status: ${widget.task.status}',
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_formatDate(widget.task.startDate)} ${widget.task.startTime.format(context)} - ${_formatDate(widget.task.endDate)} ${widget.task.endTime.format(context)}',
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: ChatWebMainPage(),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.task.taskName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding:
                  EdgeInsets.only(left: 8.0), // Adjust the padding as needed
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.grey, // Set your desired border color
                    width: 2.0, // Set your desired border width
                  ),
                ),
              ),
              child: Text(
                '${widget.task.description}',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Status: ${widget.task.status}',
            ),
            const SizedBox(height: 10),
            Text(
              '${_formatDate(widget.task.startDate)} ${widget.task.startTime.format(context)} - ${_formatDate(widget.task.endDate)} ${widget.task.endTime.format(context)}',
            ),
          ],
        ),
      ),
    );
    }
  }
}
