


import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());
class Appointment {
  DateTime startTime;
  String subject;
  String eventTime;
  String description;

  Appointment({
    required this.startTime,
    required this.subject,
    required this.eventTime,
    required this.description,
  });
}

class CalendarController extends GetxController {
  late List<Appointment> allAppointments;

  @override
  void onInit() {
    super.onInit();
    getEvents();
  }

  void initAppointments() {
    allAppointments = [
     
    ];
  }
// store in the database 
addNewEvent(){

}




  // get data from database 
  

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
    print("kkkkkkkkkkkkkkkkkkk");
    print(responseBody);
    print("kkkkkkkkkkkkkkkkkkk");

    // Assuming your response structure is similar to the provided example
    if (responseBody['message'] == 'Calender fetched') {
      var calendarList = responseBody['Calender'] as List<dynamic>;

      // Clear existing appointments before adding new ones
      allAppointments.clear();

      calendarList.forEach((calendarItem) {
        var appointment = Appointment(
          startTime: DateTime.parse(calendarItem['date'] + ' ' + calendarItem['time']),
          subject: calendarItem['subject'],
          eventTime: calendarItem['time'],
          description: calendarItem['description'],
        );

        allAppointments.add(appointment);
      });
    }
  }
}

///

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