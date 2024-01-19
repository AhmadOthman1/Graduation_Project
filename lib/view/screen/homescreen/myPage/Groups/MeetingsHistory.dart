import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/meetingHistory_controller.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/global.dart';

class ShowMeetingsHistory extends StatefulWidget {
  const ShowMeetingsHistory({Key? key, this.groupData}) : super(key: key);
  final groupData;

  @override
  _ShowMeetingsHistoryState createState() => _ShowMeetingsHistoryState();
}

final ScrollController scrollController = ScrollController();

class _ShowMeetingsHistoryState extends State<ShowMeetingsHistory> {
  late ShowMeetingHistoryController _controller;
  final ScrollController _scrollController = ScrollController();
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
    _controller = ShowMeetingHistoryController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadMeetingsHistory(
          _controller.page, widget.groupData['id']);
      setState(() {
        _controller.page++;
        _controller.meetinghistory;
      });
      print('Data loaded: ${_controller.meetinghistory.length} meetings');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meetings History'),
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
              itemCount: _controller.meetinghistory.length,
              itemBuilder: (context, index) {
                final history = _controller.meetinghistory[index];
                print("OKKKKKKKKKKKKKKKKKKKKKK");
                print(history);
                final meetingId = history['meetingId'];
                final period = history['period'];
                final startedAt=history['startedAt'];
      

                return Column(
                
                  children: [
                    ListTile(
                      title: Text('A meeting was held with id: $meetingId'),
                      subtitle:   Column(
                        children: [
                          Container(
        alignment: Alignment.centerLeft,
        child: Text('At: ${formatDate(startedAt)}'),
      ),
                                 Container(
                   
                       alignment: Alignment.centerLeft,
                      child: Text(
                          'Period: $period',
                          style: TextStyle(
                            color: period == 'Meeting is taking place now'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                    ),
                        ],
                      ),
                      
                    ),
                   
                    const Divider(
                      color: Color.fromARGB(255, 194, 193, 193),
                      thickness: 2.0,
                    ),
                  ],
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
