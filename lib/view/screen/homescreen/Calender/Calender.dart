import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Appointment> allAppointments = <Appointment>[];

  @override
  void initState() {
    super.initState();

    // Add initial events
    allAppointments.add(
      Appointment(
        startTime: DateTime.now(),
        subject: 'Meeting 1',
        remindMe: '5:35 AM',
        color: Colors.green,
      ),
    );

    allAppointments.add(
      Appointment(
        startTime: DateTime.now().add(Duration(days: 1)),
        subject: 'Meeting 2',
        remindMe: '3:35 AM',
        color: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                List<Appointment>? newAppointments = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarScreen(allAppointments, _updateAppointments)),
                );

                if (newAppointments != null && newAppointments.isNotEmpty) {
                  _updateAppointments(newAppointments);
                }
              },
              child: Text('Open Calendar'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allAppointments.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title: ${allAppointments[index].subject}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Date: ${allAppointments[index].startTime} ',
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Remind Me: ${allAppointments[index].remindMe}',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateAppointments(List<Appointment> newAppointments) {
    setState(() {
      allAppointments.addAll(newAppointments);
    });
  }
}

class CalendarScreen extends StatefulWidget {
  final List<Appointment> initialAppointments;
  final Function(List<Appointment>) onUpdateAppointments;

  CalendarScreen(this.initialAppointments, this.onUpdateAppointments);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late List<Appointment> appointments;

  @override
  void initState() {
    super.initState();
    appointments = List.from(widget.initialAppointments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Calendar'),
      ),
      body: Column(
        children: [
          SfCalendar(
            view: CalendarView.month,
            dataSource: _getCalendarDataSource(),
          ),
          ElevatedButton(
            onPressed: () async {
              List<Appointment>? newAppointments = await _showAddEventDialog(context);

              if (newAppointments != null) {
                setState(() {
                  appointments.addAll(newAppointments);
                });
                widget.onUpdateAppointments(newAppointments);
              }
            },
            child: Text('Add Event'),
          ),
        ],
      ),
    );
  }

  DataSource _getCalendarDataSource() {
    return DataSource(appointments);
  }

Future<List<Appointment>?> _showAddEventDialog(BuildContext context) async {
  TextEditingController titleController = TextEditingController();
  TimeOfDay? selectedTime;
  DateTime selectedDate = DateTime.now();

  return showDialog<List<Appointment>>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add Event'),
        content: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Event Title'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
              },
              child: Text('Select Time'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null && pickedDate != selectedDate) {
                  selectedDate = pickedDate;
                }
              },
              child: Text('Select Date'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (selectedTime != null) {
                DateTime combinedDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );

                List<Appointment> newAppointments = [
                  Appointment(
                    startTime: combinedDateTime,
                    subject: titleController.text,
                    remindMe: selectedTime!.format(context),
                    color: Colors.green,
                  ),
                ];

                print('$combinedDateTime');
                print(titleController.text);
                print('Remind Me: ${selectedTime!.format(context)}');
                Navigator.pop(context, newAppointments);
              } else {
                // Handle case where time is not selected
                // You may show an error message or take appropriate action
                print('Time not selected');
              }
            },
            child: Text('Add Event'),
          ),
        ],
      );
    },
  );
}

}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class Appointment {
  DateTime startTime;
  String subject;
  String remindMe;
  Color color;

  Appointment({
    required this.startTime,
    required this.subject,
    required this.remindMe,
    required this.color,
  });
}