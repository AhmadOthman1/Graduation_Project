import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/homescreen_controller.dart';
import 'package:growify/services/notification_service.dart';
import 'package:growify/view/screen/homescreen/NewPost/newpost.dart';
import 'package:growify/view/widget/homePage/bottomappbar.dart';
import 'package:growify/controller/home/calendar_controller/calendar_controller.dart';
import 'package:growify/controller/home/tasks_controller/tasks_controller.dart';
import 'package:growify/view/screen/homescreen/taskes/task.dart';
import 'package:quick_notify/quick_notify.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeScreenControllerImp _controller;
  CalendarController calendarController = Get.put(CalendarController());
  TasksController taskController = Get.put(TasksController());
  late List<Appointment> allAppointments = [];
  late List<Task> myTasks = [];
  late List myTasksIsendNoti = [];
  late List myEventsIsendNoti = [];
  late Timer _LocationTimer;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(HomeScreenControllerImp());
    _initController();
    taskController.initUserTasks();
    calendarController.getEvents();
    _LocationTimer = Timer.periodic(Duration(seconds: 10), (Timer timer) async {
      _evetnsAndtasks();
    });
  }

  Future<void> _initController() async {
    await _controller.connectToSSE(GetStorage().read('username'));
  }

  // for events and tasks

  Future<void> _evetnsAndtasks() async {
    // for task

    print("tasksssssssssssssssssssssssssssss");
    print("Tasks:");
    myTasks.clear();
    myTasks.addAll(tasks);

    DateTime presentDay = DateTime.now();
   

    for (var task in myTasks) {
      if (task.reminderDate != null) {
        DateTime taskRemindDate = task.reminderDate!;
        if (taskRemindDate.isAtSameMomentAs(
            DateTime(presentDay.year, presentDay.month, presentDay.day))) {
                print("yessssssssssssssss: ${task.reminderDate} ${task.reminderTime}");
          int? hour = task.reminderTime?.hour;
          int? minute = task.reminderTime?.minute;

          int presentHour = presentDay.hour;

          if (!kIsWeb) {
            presentHour += 2;
          }

          int presentMinute = presentDay.minute;
          int value = (minute ?? 0) - presentMinute;
      print("presentHour: $presentHour");
          if (hour == presentHour) {
            if (-1 <= value && value < 2) {
              // Check if task.id is not already in myTasksIsendNoti
              if (!myTasksIsendNoti.contains(task.id)) {
                myTasksIsendNoti.add(task.id);
                print("Task ID: ${task.id}");
                print("Task Name: ${task.taskName}");
                print("End Date: ${taskRemindDate}");
                print("End Time: ${task.endTime}");
                print("Description: ${task.description}");
                print("--------------");

                DateTime now = DateTime.now();
                String Noti = task.taskName;
                String EndTime = '$hour:$minute';
                String createdAt =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                  
                if (kIsWeb) {
                  QuickNotify.notify(
                    title: "Growify . " + createdAt,
                    content: "You have task: $Noti , End At : $EndTime",
                  );
                } else {
                  var playSound = true;
                  Duration timeoutAfter = Duration(seconds: 5);
                  String Noti = task.taskName;
                  await NotificationService.initializeNotification(playSound);
                  await NotificationService.showNotification(
                    title: "Growify",
                    body: "You have task: $Noti , End At : $EndTime",
                    //summary: createdAt,

                    chronometer: Duration.zero,
                    timeoutAfter: playSound ? null : timeoutAfter,
                  );
                }
              }
            }
          } 
        }
      }
    }

    // for event in calendar rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
    print("EEEEEEEEEEEEEEVVVVVVVVEEEEEEEEEEENNNNNNNNNTTTTTTTT");
    // print(allAppointments);
    print("EEEEEEEEEEEEEEVVVVVVVVEEEEEEEEEEENNNNNNNNNTTTTTTTT data");
    DateTime today = DateTime.now();
    today = today.add(Duration(hours: 2));
    
  
    allAppointments.assignAll(calendarController.allAppointments);

    for (var appointment in allAppointments) {
      if (appointment.reminderDate != null) {
          DateTime eventRemindDate = appointment.reminderDate!;
          if (eventRemindDate.isAtSameMomentAs(
            DateTime(presentDay.year, presentDay.month, presentDay.day))) {
       
        //ok here 

                  int? hourEvent = appointment.reminderTime?.hour;
          int? minuteEvent = appointment.reminderTime?.minute;

          int presentHourEvent = today.hour;

          int presentMinuteEvent = today.minute;
          int valueEvent = (minuteEvent ?? 0) - presentMinuteEvent;
      //    print("minuteEvent :$minuteEvent : ")
          print("hourEvent: $hourEvent");
          print("presentHourEvent: $presentHourEvent");
          print("valueEvent: $valueEvent");
           if (hourEvent == presentHourEvent) {
             print("My Event: ${appointment.reminderDate} : ${appointment.reminderTime}");
            if (-1 <= valueEvent && valueEvent < 2) {
               if (!myEventsIsendNoti.contains(appointment.id)) {
                myEventsIsendNoti.add(appointment.id);
                print("Upcoming Event ID: ${appointment.id}");
                print("Event Date: ${appointment.date}");
                print("Event Time: ${appointment.eventTime}");
                print("Subject: ${appointment.subject}");
                print("Description: ${appointment.description}");
               // print("timeDifference:${timeDifference}");
                print("--------------");

                // send to notification

                DateTime now = DateTime.now();
                String Noti = appointment.subject;
                String EndTime = appointment.eventTime;
                String createdAt =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                if (kIsWeb) {
                  QuickNotify.notify(
                    title: "Growify . " + createdAt,
                    content: "You have event: $Noti ,  At : $EndTime",
                  );
                } else {
                  var playSound = true;
                  Duration timeoutAfter = Duration(seconds: 5);

                  await NotificationService.initializeNotification(playSound);
                  await NotificationService.showNotification(
                    title: "Growify",
                    body: "You have event: $Noti ,  At : $EndTime",
                    //summary: createdAt,

                    chronometer: Duration.zero,
                    timeoutAfter: playSound ? null : timeoutAfter,
                  );
                }
              }

            }
           }
      }
        /////// sameeeeeeeeeeee
       // DateTime eventDateTime = DateTime.parse(appointment.date!);

      /*  if (eventDateTime.year == today.year &&
            eventDateTime.month == today.month &&
            eventDateTime.day == today.day) {
        /*  if (appointment.eventTime != null) {
            DateTime eventTime =
                DateTime.parse("${appointment.date} ${appointment.eventTime}");

            int timeDifference = today.difference(eventTime).inMinutes;
        
            if (timeDifference >= -30 && timeDifference <= 1) {
              if (!myEventsIsendNoti.contains(appointment.id)) {
                myEventsIsendNoti.add(appointment.id);
                print("Upcoming Event ID: ${appointment.id}");
                print("Event Date: ${appointment.date}");
                print("Event Time: ${appointment.eventTime}");
                print("Subject: ${appointment.subject}");
                print("Description: ${appointment.description}");
                print("timeDifference:${timeDifference}");
                print("--------------");

                // send to notification

                DateTime now = DateTime.now();
                String Noti = appointment.subject;
                String EndTime = appointment.eventTime;
                String createdAt =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                if (kIsWeb) {
                  QuickNotify.notify(
                    title: "Growify . " + createdAt,
                    content: "You have event: $Noti ,  At : $EndTime",
                  );
                } else {
                  var playSound = true;
                  Duration timeoutAfter = Duration(seconds: 5);

                  await NotificationService.initializeNotification(playSound);
                  await NotificationService.showNotification(
                    title: "Growify",
                    body: "You have event: $Noti ,  At : $EndTime",
                    //summary: createdAt,

                    chronometer: Duration.zero,
                    timeoutAfter: playSound ? null : timeoutAfter,
                  );
                }
              }
            }
          }*/
        }*/
      }
    }
  }

  @override
  void dispose() {
    _LocationTimer.cancel();
    super.dispose();
  }
  // ok

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenControllerImp>(
      builder: (controller) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => kIsWeb
    ? showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return NewPost();
        },
      )
    : Get.to(
        NewPost(
          profileImage: GetStorage().read('photo'),
        ),
      ),

          child: const Icon(Icons.post_add_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  ...List.generate(
                    controller.titlebottomappbar.length,
                    ((index) {
                      int i = index > 2 ? index - 1 : index;
                      return Expanded(
                        child: BottommAppBar(
                          textbutton: controller.titlebottomappbar[index],
                          icondata: controller.icons[index],
                          onPressed: () {
                            controller.changePage(index);
                          },
                          active:
                              controller.currentpage == index ? true : false,
                        ),
                      );
                    }),
                  )
                ],
              ),
            ],
          ),
        ),
        body: controller.listPage.elementAt(controller.currentpage),
      ),
    );
  }
}
