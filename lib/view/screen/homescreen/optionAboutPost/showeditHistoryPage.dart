import 'package:flutter/material.dart';
import 'package:growify/controller/home/OptionAboutPost_Controller/ShowPostEditPageHistory_controller.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/meetingHistory_controller.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/global.dart';

class ShowEditPageHistory extends StatefulWidget {
  const ShowEditPageHistory({Key? key, this.postId}) : super(key: key);
  final postId;

  @override
  _ShowEditPageHistoryState createState() => _ShowEditPageHistoryState();
}

final ScrollController scrollController = ScrollController();

class _ShowEditPageHistoryState extends State<ShowEditPageHistory> {
  late ShowEditPageController _controller;
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");

  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
    _controller = ShowEditPageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Edit History'),
      ),
      body: Column(
        children: [
          const Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: _controller.getPostEditHistory(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading data'),
                  );
                } else {
                  // Data has been loaded successfully
                  final List<Map<String, dynamic>> EditPosthistorylocal =
                      _controller.EditPosthistory;

                  return EditPosthistorylocal.isEmpty
                      ? Center(
                          child: Text("No edit history available"),
                        )
                      : ListView.builder(
                          itemCount: EditPosthistorylocal.length,
                          itemBuilder: (context, index) {
                            if (index < EditPosthistorylocal.length) {
                              final history = EditPosthistorylocal[index];
                              print("OKKKKKKKKKKKKKKKKKKKKKK");
                              print(history);

                              final PreviousText = history['PreviousText'];
                              final updatedAt = history['updatedAt'];

                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        'Old Post Content: $PreviousText'),
                                    subtitle: Text(
                                              'Updated At: ${formatDate(updatedAt)}'),
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 194, 193, 193),
                                    thickness: 2.0,
                                  ),
                                ],
                              );
                            } else {
                             
                              return Container(); 
                            }
                          },
                        );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
