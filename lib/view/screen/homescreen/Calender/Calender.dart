import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Appointment> allAppointments = <Appointment>[];

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
                  MaterialPageRoute(builder: (context) => CalendarScreen(allAppointments)),
                );

                if (newAppointments != null) {
                  setState(() {
                    allAppointments.addAll(newAppointments);
                  });
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
                        'Time: ${allAppointments[index].startTime} to ${allAppointments[index].endTime}',
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
}

class CalendarScreen extends StatefulWidget {
  final List<Appointment> initialAppointments;

  CalendarScreen(this.initialAppointments);

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

                // Pass the updated appointments back to the MainScreen
                Navigator.pop(context, appointments);
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
    DateTime selectedDate = DateTime.now();

    return showDialog<List<Appointment>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Event Title'),
              ),
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
                List<Appointment> newAppointments = [
                  Appointment(
                    startTime: selectedDate,
                    endTime: selectedDate.add(Duration(hours: 2)),
                    subject: titleController.text,
                    color: Colors.green,
                  )
                ];
                print('$selectedDate');
                print(titleController.text);
                Navigator.pop(context, newAppointments);
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