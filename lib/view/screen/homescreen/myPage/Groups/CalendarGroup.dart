import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/calendarGroup_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalenderGroup extends StatefulWidget {
  const CalenderGroup(
      {super.key,
      this.isAdmin,
      this.members,
      this.isUserAdminInPage,
      this.groupData});

  final isAdmin;
  final members;
  final isUserAdminInPage;
  final groupData;

  @override
  _CalenderGroupPageState createState() => _CalenderGroupPageState();
}

class _CalenderGroupPageState extends State<CalenderGroup> {
  late List<Appointment> appointments;
  DateTime selectedDate = DateTime.now();
  late DateTime firstDay;
  late DateTime lastDay;
  late DateTime focusedDay;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CalendarGroupController controller = Get.put(CalendarGroupController());

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
        future: controller.getEvents(widget.groupData['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Initialize dependent state here after fetching events
            appointments = controller.getAppointmentsForDate(selectedDate);

            return Column(
              children: [
                _buildCalendar(),
                // Inside the build method, locate the ElevatedButton widget and wrap it with Visibility
                Visibility(
                  visible: widget.isAdmin ||
                      (widget.isUserAdminInPage != null &&
                          widget.isUserAdminInPage == true),
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 370,
                    child: ElevatedButton(
                      onPressed: () async {
                        List<Appointment>? newAppointments =
                            await _showAddEventDialog(context);

                        if (newAppointments != null) {
                          await controller.addNewEvent(newAppointments,widget.groupData['id']);

                          setState(() {
                            appointments =
                                controller.getAppointmentsForDate(selectedDate);
                          });
                        }
                      },
                      child: const Text('Add Event'),
                    ),
                  ),
                ),

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
                    Spacer(),
                    // Inside the build method, locate the PopupMenuButton widget and wrap it with Visibility
                    Visibility(
                      visible: widget.isAdmin ||
                          (widget.isUserAdminInPage != null &&
                              widget.isUserAdminInPage == true),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (String option) async {
                          var appointmentId = appointments[index]?.id ??
                              0; // Use a default value if id is null
                          var message = await controller.onMoreOptionSelected(
                              option, appointmentId,widget.groupData['id']);

                          (message != null)
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomAlertDialog(
                                      title: 'Aret',
                                      icon: Icons.error,
                                      text: message,
                                      buttonText: 'OK',
                                    );
                                  },
                                )
                              : null;
                          setState(() {
                            appointments.removeWhere((appointment) =>
                                appointment.id == appointmentId);
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return controller.moreOptions.map((String option) {
                            return PopupMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList();
                        },
                      ),
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

  Future<List<Appointment>?> _showAddEventDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TimeOfDay? selectedTime;

    return showDialog<List<Appointment>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Event'),
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "Enter Your Event Description",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    labelText: "Event Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () async {
                      selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                    },
                    child: const Text('Select Time'),
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
              child: const Text('Cancel'),
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
                        eventTime: selectedTime!.format(context),
                        description: descriptionController.text,
                      ),
                    ];

                    print('$combinedDateTime');
                    print(titleController.text);
                    print(descriptionController.text);
                    print('Remind Me: ${selectedTime!.format(context)}');
                    Navigator.pop(context, newAppointments);
                  } else {
                    print('Time not selected');
                  }
                }
              },
              child: const Text('Add Event'),
            ),
          ],
        );
      },
    );
  }
}
