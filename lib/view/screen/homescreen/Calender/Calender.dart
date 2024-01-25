import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/calendar_controller/calendar_controller.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/chat/chatForWeb/chatWebmainpage.dart';
import 'package:growify/view/screen/homescreen/taskes/tasksmainpage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<Calender> {
  late List<Appointment> appointments;
  DateTime selectedDate = DateTime.now();
  late DateTime firstDay;
  late DateTime lastDay;
  late DateTime focusedDay;
  TimeOfDay? reminderTime;
  DateTime? reminderDate;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CalendarController controller = Get.put(CalendarController());
  late HomePageControllerImp HPcontroller = Get.put(HomePageControllerImp());
  ImageProvider<Object> avatarImage =
      const AssetImage("images/profileImage.jpg");
  String name =
      GetStorage().read("firstname") + " " + GetStorage().read("lastname");
  final LogOutButtonControllerImp logoutController =
      Get.put(LogOutButtonControllerImp());
  @override
  void initState() {
    super.initState();
    // Initialize non-dependent state here
    firstDay = DateTime.now().subtract(const Duration(days: 365));
    lastDay = DateTime.now().add(const Duration(days: 365));
    focusedDay = DateTime.now();
    updateAvatarImage();
  }
void updateAvatarImage() {
    String profileImage = GetStorage().read("photo") ?? "";
    setState(() {
      avatarImage = (profileImage.isNotEmpty)
          ? Image.network("$urlStarter/$profileImage").image
          : const AssetImage("images/profileImage.jpg");
    });
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
            child: Container(
              child: FutureBuilder(
                future: controller.getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // Initialize dependent state here after fetching events
                    appointments =
                        controller.getAppointmentsForDate(selectedDate);

                    return _buildWebLayout();
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
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
  }

  Widget _buildWebLayout() {
    return kIsWeb
        ? Column(
            children: [
              Container(
                child: Column(
                  children: [
                    _buildCalendar(),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
                          List<Appointment>? newAppointments =
                              await _showAddEventDialog(context);

                          if (newAppointments != null) {
                            await controller.addNewEvent(newAppointments);

                            setState(() {
                              appointments = controller
                                  .getAppointmentsForDate(selectedDate);
                            });
                          }
                        },
                        child: const Text('Add Event'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: _buildAppointmentList(),
              ),
            ],
          )
        : Column(
            children: [
              _buildCalendar(),
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: 370,
                child: ElevatedButton(
                  onPressed: () async {
                    List<Appointment>? newAppointments =
                        await _showAddEventDialog(context);

                    if (newAppointments != null) {
                      await controller.addNewEvent(newAppointments);

                      setState(() {
                        appointments =
                            controller.getAppointmentsForDate(selectedDate);
                      });
                    }
                  },
                  child: const Text('Add Event'),
                ),
              ),
              _buildAppointmentList(),
            ],
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
    return kIsWeb
        ? Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return _buildAppointmentCard(index);
              },
            ),
          )
        : Expanded(
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return _buildAppointmentCard(index);
              },
            ),
          );
  }

  Widget _buildAppointmentCard(int index) {
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
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (String option) async {
                  var appointmentId = appointments[index]?.id ?? 0;
                  var message = await controller.onMoreOptionSelected(
                      option, appointmentId);

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
                    appointments.removeWhere(
                        (appointment) => appointment.id == appointmentId);
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
  }

  Future<List<Appointment>?> _showAddEventDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TimeOfDay? selectedTime;
    String _formatDate(DateTime date) {
      return '${date.year}-${date.month}-${date.day}';
    }

    return showDialog<List<Appointment>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Event'),
          content: SingleChildScrollView(
            child: Form(
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
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: const Text(
                          'Remind Me : ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              onPressed: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: reminderDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null) {
                                  //   setState(() {
                                  reminderDate = pickedDate;
                                  //  });
                                }
                              },
                              child: const Text('Select Date'),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              onPressed: () async {
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: reminderTime ?? TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  //  setState(() {
                                  reminderTime = pickedTime;
                                  // });
                                }
                              },
                              child: const Text('Select Time'),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Obx(
                              () => Checkbox(
                                value: controller.isSaveVisible.value,
                                onChanged: (value) {
                                  controller.isSaveVisible.value = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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
                if (controller.isSaveVisible.value &&
                    (reminderDate == null || reminderTime == null)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Reminder not selected'),
                        content:
                            const Text('Please select reminder date and time.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
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
                          reminderDate: reminderDate,
                          reminderTime: reminderTime,
                        ),
                      ];

                      print('$combinedDateTime');
                      print(titleController.text);
                      print(descriptionController.text);
                      print('Remind Me: ${selectedTime!.format(context)}');
                      print(titleController.text);
                      Navigator.pop(context, newAppointments);
                    } else {
                      print('Time not selected');
                    }
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
