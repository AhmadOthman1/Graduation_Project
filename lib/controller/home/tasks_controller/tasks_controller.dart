import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/taskes/task.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

late List<Task> tasks = [];
TimeOfDay stringToTimeOfDay(String time) {
  List<String> parts = time.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

class TasksController extends GetxController {
  getUserTasks() async {
    var url = "$urlStarter/user/getUserTasks";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  initUserTasks() async {
    var response = await getUserTasks();
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      initUserTasks();
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return;
    } else if (response.statusCode == 200) {
      tasks.clear();
      var responseBody = jsonDecode(response.body);
      //print(responseBody['tasks']);
      for (Map<String, dynamic> taskData in responseBody['tasks']) {
        Task task = Task(
          taskData['taskName'],
          taskData['description'],
          stringToTimeOfDay(taskData['startTime']),
          stringToTimeOfDay(taskData['endTime']),
          DateTime.parse(taskData['startDate']),
          DateTime.parse(taskData['endDate']),
          taskData['status'],
          taskData['id'],
        );
        tasks.add(task);
        print(task);
      }

      // Now `apiTasks` contains Task objects from the API
    }
  }

  postChangeUserTaskStatus(taskId, newValue) async {
    var url = "$urlStarter/user/ChangeUserTaskStatus";
    Map<String, dynamic> jsonData = {
      "taskId": taskId,
      "newValue": newValue,
    };
    String jsonString = jsonEncode(jsonData);
    var response = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  changeUserTaskStatus(task, newValue) async {
    var response = await postChangeUserTaskStatus(task.id, newValue);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      changeUserTaskStatus(task, newValue);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return;
    } else if (response.statusCode == 200) {
      print(task.id);
      return true;
    }
    return false;
  }
String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
  String _formatTimeOfDay(TimeOfDay time) {
  
  return '${time.hour}:${time.minute}:00';
 
}
  postCreateUserTask(task) async {
    var url = "$urlStarter/user/CreateUserTask";
    Map<String, dynamic> jsonData = {
      "taskName": task.taskName,
      "description":  task.description,
      "startTime":  _formatTimeOfDay(task.startTime),
      "endTime":  _formatTimeOfDay(task.endTime),
      "startDate":  _formatDate(task.startDate),
      "endDate":  _formatDate(task.endDate),
      "status": task.status,
    };
    String jsonString = jsonEncode(jsonData);
    var response = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  createUserTask(task) async {
    var response = await postCreateUserTask(task);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      createUserTask(task);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return;
    } else if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['taskId']);
      return responseBody['taskId'];
    }
  }
}
