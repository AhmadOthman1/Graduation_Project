import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


LogOutButtonControllerImp _logoutController = Get.put(LogOutButtonControllerImp());

class Appointment {
  int? id; // Make id nullable (optional)
  String?date;
  DateTime startTime;
  String subject;
  String eventTime;
  String description;
  TimeOfDay? reminderTime;
  DateTime? reminderDate;

  Appointment({
    this.id,
    this.date,
    required this.startTime,
    required this.subject,
    required this.eventTime,
    required this.description,
    this.reminderTime,
    this.reminderDate, 
  });
}

class CalendarController extends GetxController {
  RxBool isSaveVisible = true.obs;
  late List<Appointment> allAppointments = [];

  final RxList<String> moreOptions = <String>[
    'Delete',
  ].obs;

  onMoreOptionSelected(String option, int id) async {
    switch (option) {
      case 'Delete':
        return await deleteEvent(id);
        break;
    }
  }

  deleteEvent(id) async {
    var url = "$urlStarter/user/deleteUserEvent";
    Map<String, dynamic> jsonData = {
      "eventId": id,
    };
    String jsonString = jsonEncode(jsonData);
    var response = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      deleteEvent(id);
      return ;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return responseBody['message'];
    } else if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      allAppointments.removeWhere((Appointment) => Appointment.id == id);
      return responseBody['message'];
    }
  }

  @override
  void onInit() {
    super.onInit();

  }

  void initAppointments() {
    allAppointments = [];
  }
  String formatTimeOfDay(TimeOfDay timeOfDay) {
  return '${timeOfDay.hour}:${timeOfDay.minute}';
}

  // store in the database
  addNewEvent(newAppointments) async {
   
    var url = "$urlStarter/user/addNewUserEvent";
    Map<String, dynamic> jsonData = {
      "subject": newAppointments[0].subject,
      "description": newAppointments[0].description,
      "startTime": newAppointments[0].startTime.toString(),
       "reminderDate": newAppointments[0].reminderDate?.toIso8601String(),
  "reminderTime": newAppointments[0].reminderTime != null
      ? formatTimeOfDay(newAppointments[0].reminderTime!)
      : null,
    };
    String jsonString = jsonEncode(jsonData);
    var response = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print("kkkkkkkkkkkkkk");
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      addNewEvent(newAppointments);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return;
    } else if (response.statusCode == 200) {
      Get.back();
      return true;
    }
  }

  TimeOfDay stringToTimeOfDay(String time) {
  List<String> parts = time.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

  // get data from the database
  Future<void> getEvents() async {
    var url = "$urlStarter/user/getUserCalender";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });

    print(response.statusCode);
    print('bearer ' + GetStorage().read('accessToken'));

    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      await getEvents();
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    } else if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
    } else if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
  //    print("kkkkkkkkkkkkkkkkkkk");
  //    print(responseBody);
   //   print("kkkkkkkkkkkkkkkkkkk");

      // Assuming your response structure is similar to the provided example
      if (responseBody['message'] == 'Calender fetched') {
        var calendarList = responseBody['Calender'] as List<dynamic>;

        // Clear existing appointments before adding new ones
        allAppointments.clear();

        calendarList.forEach((calendarItem) {
          var appointment = Appointment(
            startTime: DateTime.parse(
                calendarItem['date'] + ' ' + calendarItem['time']),
            subject: calendarItem['subject'],
            eventTime: calendarItem['time'],
            description: calendarItem['description'],
            id: calendarItem['id'],
            date:calendarItem['date'],
             reminderDate: calendarItem['reminderDate'] != null
      ? DateTime.parse(calendarItem['reminderDate'])
      : null,
          reminderTime: calendarItem['reminderTime'] != null
      ? stringToTimeOfDay(calendarItem['reminderTime'])
      : null,
          );

          allAppointments.add(appointment);
        });
      }
    }
  }

  List<dynamic> getEventsForDay(DateTime day) {
    List<dynamic> events = [];

    if (getAppointmentsForDate(day).isNotEmpty) {
      events.add(true);
    }

    return events;
  }

  List<Appointment> getAppointmentsForDate(DateTime date) {
    return allAppointments
        .where((appointment) =>
            appointment.startTime.year == date.year &&
            appointment.startTime.month == date.month &&
            appointment.startTime.day == date.day)
        .toList();
  }

  void addAppointments(List<Appointment> newAppointments) {
    allAppointments.addAll(newAppointments);
  }
}
