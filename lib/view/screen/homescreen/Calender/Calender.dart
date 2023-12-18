import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/calendar_controller/calendar_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<Calender> {
  late List<Appointment> allAppointments;
  late List<Appointment> appointments;
  DateTime selectedDate = DateTime.now();
  late DateTime firstDay;
  late DateTime lastDay;
  late DateTime focusedDay;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CalendarController controller =
      Get.put(CalendarController());

  @override
  void initState() {
    super.initState();
    // here get data from database
    /*List<Appointment> newAppointments2 = [
                    Appointment(
                     startTime: ,
                      subject: ,
                      remindMe: ,
                    )];
    then use this function _addAppointment(newAppointments2)
    */

    allAppointments = [
      Appointment(
        startTime: DateTime(2023, 12, 14),
        subject: 'Meeting 1',
        remindMe: '5:35 AM',
      ),
      Appointment(
        startTime: DateTime(2023, 12, 15),
        subject: 'Meeting 2',
        remindMe: '3:35 AM',
      ),
    ];

    appointments = _getAppointmentsForDate(selectedDate);

    firstDay = DateTime.now().subtract(Duration(days: 365));
    lastDay = DateTime.now().add(Duration(days: 365));
    focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
      ),
      body: Column(
        children: [
          _buildCalendar(),
          Container(
            margin: EdgeInsets.only(top: 20), // Adjusted margin
            width: 370,
            child: ElevatedButton(
              onPressed: () async {
                List<Appointment>? newAppointments =
                    await _showAddEventDialog(context);

                if (newAppointments != null) {
                  _addAppointment(newAppointments);
                }
              },
              child: Text('Add Event'),
            ),
          ),
          _buildAppointmentList(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,
      calendarFormat: CalendarFormat.month,
      selectedDayPredicate: (day) {
        return isSameDay(selectedDate, day!);
      },
      eventLoader: _getEventsForDay,
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(selectedDate, selectedDay)) {
          setState(() {
            selectedDate = selectedDay;
            appointments = _getAppointmentsForDate(selectedDate);
          });
        }
      },
    );
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    List<dynamic> events = [];

    // Check if there are events for the specified day
    if (_getAppointmentsForDate(day).isNotEmpty) {
      events.add(true);
    }

    return events;
  }

  List<Appointment> _getAppointmentsForDate(DateTime date) {
    return allAppointments
        .where((appointment) =>
            appointment.startTime.year == date.year &&
            appointment.startTime.month == date.month &&
            appointment.startTime.day == date.day)
        .toList();
  }

  Widget _buildAppointmentList() {
    return Expanded(
      child: ListView.builder(
        itemCount: appointments.length,
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
                  'Title: ${appointments[index].subject}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Date: ${appointments[index].startTime} ',
                ),
                SizedBox(height: 8.0),
                Text(
                  'Remind Me: ${appointments[index].remindMe}',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addAppointment(List<Appointment> newAppointments) {
    setState(() {
      allAppointments.addAll(newAppointments);
      appointments = _getAppointmentsForDate(selectedDate);
    });
  }

  Future<List<Appointment>?> _showAddEventDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TimeOfDay? selectedTime;

    return showDialog<List<Appointment>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Enter Your Event Title",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    labelText: "Event Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                Container(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () async {
                      selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                    },
                    child: Text('Select Time'),
                  ),
                ),
              ],
            ),
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
                if (formKey.currentState!.validate()) {
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
                      ),
                    ];

                    print('$combinedDateTime');
                    print(titleController.text);
                    print('Remind Me: ${selectedTime!.format(context)}');
                    Navigator.pop(context, newAppointments);
                  } else {
                    print('Time not selected');
                  }
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

class Appointment {
  DateTime startTime;
  String subject;
  String remindMe;

  Appointment({
    required this.startTime,
    required this.subject,
    required this.remindMe,
  });
}
