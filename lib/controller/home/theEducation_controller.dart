import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

class EducationController extends GetxController {
/*  final RxList<Map<String, String>> educationLevels =
      <Map<String, String>>[
    {
      'Specialty': 'Software Developer',
      'School': 'ABC Tech',
      'Description': 'Developing awesome apps',
      'Start Date': '2022-01-01',
      'End Date': '2022-12-31',
    },
    {
      'Specialty': 'UI/UX Designer',
      'School': 'XYZ Design',
      'Description': 'Creating beautiful interfaces',
      'Start Date': '2021-06-15',
      'End Date': '2022-01-15',
    },
    {
      'Specialty': 'Project Manager',
      'School': '123 Projects',
      'Description': 'Managing various projects',
      'Start Date': '2020-03-10',
      'End Date': '2021-06-10',
    },
    {
      'Specialty': 'Data Analyst',
      'School': 'Data Insights',
      'Description': 'Analyzing and interpreting data',
      'Start Date': '2019-09-05',
      'End Date': '2020-03-05',
    },
    {
      'Specialty': 'Marketing Specialist',
      'School': 'Marketing Pro',
      'Description': 'Executing marketing campaigns',
      'Start Date': '2018-04-20',
      'End Date': '2019-09-20',
    },
  ].obs;*/

  // Define a dynamic RxList
  final RxList<Map<String, String>> educationLevels =
      <Map<String, String>>[].obs;

  // Function to set data in educationLevels
  void setEducationLevels(List<Map<String, String>> data) {
    educationLevels.assignAll(data);
  }

  final TextEditingController specialtyController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final RxBool isAddingEducation = false.obs;
  final RxBool isSaveVisible = false.obs;
  final GlobalKey<FormState> educationFormKey = GlobalKey<FormState>();
  final RxInt editingIndex = RxInt(-1);

  Future<void> pickStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      startDateController.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      isSaveVisible.value = true; // Show the "Save" button
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      endDateController.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      isSaveVisible.value = true; // Show the "Save" button
    }
  }

  void addNewEducation() {
    specialtyController.clear();
    schoolController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();

    isSaveVisible.value = true; // Show the "Save" button
    isAddingEducation.value = true; // Show the Form
  }

  void undoEducation() {
    specialtyController.clear();
    schoolController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();

    isSaveVisible.value = false; // Hide the "Save" button
    isAddingEducation.value = false; // Hide the Form
  }

  Future<void> saveEducation() async {
    if (educationFormKey.currentState!.validate()) {
      if (editingIndex.value == -1) {
        //send the data for the server
        var url = urlStarter + "/user/addEducationLevel";
        Map<String, dynamic> jsonData = {
          'email': GetStorage().read("loginemail"),
          'Specialty': specialtyController.text,
          'School': schoolController.text,
          'Description': descriptionController.text,
          'StartDate': startDateController.text,
          'EndDate': endDateController.text,
        };
        String jsonString = jsonEncode(jsonData);
        var responce =
            await http.post(Uri.parse(url), body: jsonString, headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });

        if (responce.statusCode == 409 || responce.statusCode == 500) {
          var resbody = jsonDecode(responce.body);
          return resbody['message'];
        } else if (responce.statusCode == 200) {
          var resbody = jsonDecode(responce.body);
          print(resbody['message']);
          // Add new experience
          educationLevels.add({
            'id': resbody['message'].toString(),
            'Specialty': specialtyController.text,
            'School': schoolController.text,
            'Description': descriptionController.text,
            'Start Date': startDateController.text,
            'End Date': (endDateController.text != "")
                ? endDateController.text
                : "Present",
          });
        }
      } else {
        var url = urlStarter + "/user/editEducationLevel";
        Map<String, dynamic> jsonData = {
          'email': GetStorage().read("loginemail"),
          'id': educationLevels[editingIndex.value]['id'],
          'Specialty': specialtyController.text,
          'School': schoolController.text,
          'Description': descriptionController.text,
          'StartDate': startDateController.text,
          'EndDate': endDateController.text,
        };
        String jsonString = jsonEncode(jsonData);
        var responce =
            await http.post(Uri.parse(url), body: jsonString, headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });

        if (responce.statusCode == 409 || responce.statusCode == 500) {
          var resbody = jsonDecode(responce.body);
          return resbody['message'];
        } else if (responce.statusCode == 200) {
          educationLevels[editingIndex.value] = {
            'Specialty': specialtyController.text,
            'School': schoolController.text,
            'Description': descriptionController.text,
            'Start Date': startDateController.text,
            'End Date': endDateController.text,
            // take edit data from array save in database just use assignAll()
            // see setPracticalExperiences() in the top
          };

          // Reset editingIndex after editing
          editingIndex.value = -1;
        }
        // Edit existing experience
      }

      // Clear controllers
      specialtyController.clear();
      schoolController.clear();
      descriptionController.clear();
      startDateController.clear();
      endDateController.clear();

      isAddingEducation.value = false; // Hide the Form
      isSaveVisible.value = false; // Hide the "Save" button
    }
  }

  void editEducation(int index) {
    editingIndex.value = index;
    // Set controllers with existing values for editing
    specialtyController.text = educationLevels[index]['Specialty'] ?? '';
    schoolController.text = educationLevels[index]['School'] ?? '';
    descriptionController.text = educationLevels[index]['Description'] ?? '';
    startDateController.text = educationLevels[index]['Start Date'] ?? '';
    endDateController.text = educationLevels[index]['End Date'] == "Present"
        ? ""
        : educationLevels[index]['End Date'] ?? '';
    // Set isAddingExperience to true to show the form for editing
    isAddingEducation.value = true;
    isSaveVisible.value = true; // Show the "Save" button
  }

  Future<void> removeEducation(int index) async {
    var url = urlStarter + "/user/deleteEducationLevele";
    Map<String, dynamic> jsonData = {
      'email': GetStorage().read("loginemail"),
      'id': educationLevels[index]['id'],
    };
    String jsonString = jsonEncode(jsonData);
    var responce = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
    });

    if (responce.statusCode == 409 || responce.statusCode == 500) {
      var resbody = jsonDecode(responce.body);
      return resbody['message'];
    } else if (responce.statusCode == 200) {
      educationLevels.removeAt(index);
      isSaveVisible.value = false; // Hide the "Save" button
      isAddingEducation.value = false; // Hide the Form
    }
  }
}
