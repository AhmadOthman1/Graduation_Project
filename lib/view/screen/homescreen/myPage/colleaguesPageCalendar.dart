import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/myPage_Controller/colleaguespageCalendar_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ColleaguesPageCalender extends StatefulWidget {
  const ColleaguesPageCalender({super.key, this.pageId});
  final pageId;

  @override
  _ColleaguesPageCalenderState createState() => _ColleaguesPageCalenderState();
}

class _ColleaguesPageCalenderState extends State<ColleaguesPageCalender> {
  late List<Appointment> appointments;
  DateTime selectedDate = DateTime.now();
  late DateTime firstDay;
  late DateTime lastDay;
  late DateTime focusedDay;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ColleaguesPageCalendarController controller = Get.put(ColleaguesPageCalendarController());

  @override
  void initState() {
    super.initState();
    // Initialize non-dependent state here
    firstDay = DateTime.now().subtract(const Duration(days: 365));
    lastDay = DateTime.now().add(const Duration(days: 365));
    focusedDay = DateTime.now();
  }

  bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
      ),
      body: FutureBuilder(
        future: controller.getEvents(widget.pageId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Initialize dependent state here after fetching events
            appointments = controller.getAppointmentsForDate(selectedDate);

            return Column(
              children: [
                _buildCalendar(),
                _buildAppointmentList(),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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
        return isSameDay(selectedDate, day);
      },
      eventLoader: controller.getEventsForDay,
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(selectedDate, selectedDay)) {
          setState(() {
            selectedDate = selectedDay;

            // Check if the selected day is in the current month
            if (!isSameMonth(selectedDate, focusedDay)) {
              focusedDay = DateTime(focusedDay.year, focusedDay.month, 1);
            }

            appointments = controller.getAppointmentsForDate(selectedDate);
            this.focusedDay = focusedDay;
          });
        }
      },
    );
  }

  Widget _buildAppointmentList() {
    return Expanded(
      child: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          String formattedDate =
              DateFormat('yyyy-MM-dd').format(appointments[index].startTime);

          return Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Title: ${appointments[index].subject}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Description: ${appointments[index].description}',
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Date: $formattedDate',
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Time: ${appointments[index].eventTime}',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
