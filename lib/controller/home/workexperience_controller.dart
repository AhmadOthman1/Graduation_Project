// experience_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExperienceController extends GetxController {
 /* final RxList<Map<String, String>> practicalExperiences =
      <Map<String, String>>[
    {
      'Specialty': 'Software Developer',
      'Company': 'ABC Tech',
      'Description': 'Developing awesome apps',
      'Start Date': '2022-01-01',
      'End Date': '2022-12-31',
    },
    {
      'Specialty': 'UI/UX Designer',
      'Company': 'XYZ Design',
      'Description': 'Creating beautiful interfaces',
      'Start Date': '2021-06-15',
      'End Date': '2022-01-15',
    },
    {
      'Specialty': 'Project Manager',
      'Company': '123 Projects',
      'Description': 'Managing various projects',
      'Start Date': '2020-03-10',
      'End Date': '2021-06-10',
    },
    {
      'Specialty': 'Data Analyst',
      'Company': 'Data Insights',
      'Description': 'Analyzing and interpreting data',
      'Start Date': '2019-09-05',
      'End Date': '2020-03-05',
    },
    {
      'Specialty': 'Marketing Specialist',
      'Company': 'Marketing Pro',
      'Description': 'Executing marketing campaigns',
      'Start Date': '2018-04-20',
      'End Date': '2019-09-20',
    },
  ].obs;*/

    final RxList<Map<String, String>> practicalExperiences = <Map<String, String>>[].obs;

  // Function to set data in practicalExperiences
  void setPracticalExperiences(List<Map<String, String>> data) {
    practicalExperiences.assignAll(data);
  }











  final TextEditingController specialtyController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final RxBool isAddingExperience = false.obs;
  final RxBool isSaveVisible = false.obs;
  final GlobalKey<FormState> experienceFormKey = GlobalKey<FormState>();
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

  void addNewExperience() {
    specialtyController.clear();
    companyController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();

    isSaveVisible.value = true; // Show the "Save" button
    isAddingExperience.value = true; // Show the Form
  }

  void undoExperience() {
    specialtyController.clear();
    companyController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();

    isSaveVisible.value = false; // Hide the "Save" button
    isAddingExperience.value = false; // Hide the Form
  }

 void saveExperience() {
    if (experienceFormKey.currentState!.validate()) {
      if (editingIndex.value == -1) {
        // Add new experience
        practicalExperiences.add({
          'Specialty': specialtyController.text,
          'Company': companyController.text,
          'Description': descriptionController.text,
          'Start Date': startDateController.text,
          'End Date': endDateController.text,
        });
      } else {
        // Edit existing experience
        practicalExperiences[editingIndex.value] = {
          'Specialty': specialtyController.text,
          'Company': companyController.text,
          'Description': descriptionController.text,
          'Start Date': startDateController.text,
          'End Date': endDateController.text,
        };

        // Reset editingIndex after editing
        editingIndex.value = -1;
      }

      // Clear controllers
      specialtyController.clear();
      companyController.clear();
      descriptionController.clear();
      startDateController.clear();
      endDateController.clear();

      isAddingExperience.value = false; // Hide the Form
      isSaveVisible.value = false; // Hide the "Save" button
    }
  }

  void editExperience(int index) {
    editingIndex.value = index;
    // Set controllers with existing values for editing
    specialtyController.text = practicalExperiences[index]['Specialty'] ?? '';
    companyController.text = practicalExperiences[index]['Company'] ?? '';
    descriptionController.text = practicalExperiences[index]['Description'] ?? '';
    startDateController.text = practicalExperiences[index]['Start Date'] ?? '';
    endDateController.text = practicalExperiences[index]['End Date'] ?? '';
    // Set isAddingExperience to true to show the form for editing
    isAddingExperience.value = true;
    isSaveVisible.value = true; // Show the "Save" button
  }

  void removeExperience(int index) {
    practicalExperiences.removeAt(index);
    isSaveVisible.value = false; // Hide the "Save" button
    isAddingExperience.value = false; // Hide the Form
  }
}
