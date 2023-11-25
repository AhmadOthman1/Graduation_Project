import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/theEducation_controller.dart';




class Education extends StatelessWidget {
  final EducationController controller = Get.put(EducationController());

  @override
  Widget build(BuildContext context) {

    //RECIVE data from the setting controller from database 

                      var args = Get.arguments;
    List<Map<String, String>> educationLevel =
        args != null ? args['educationLevel'] : [];

            // Set the data in educationLevels
    controller.setEducationLevels(educationLevel);








    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Education Level",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                onPressed: controller.addNewEducation,
                color: Color.fromARGB(255, 85, 191, 218),
                textColor: Colors.white,
                child: Text('Add New Education Level'),
              ),
              SizedBox(height: 16),
              Obx(() {
                return Visibility(
                  visible: controller.isAddingEducation.value,
                  child: Form(
                    key: controller.educationFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.specialtyController,
                          decoration: InputDecoration(
                            hintText: "Enter Your Specialty",
                            hintStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            label: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 9),
                                child: Text("Specialty")),
                            suffixIcon: InkWell(
                                child: Icon(Icons.work_history_sharp),
                                onTap: () {}),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: controller.schoolController,

                          decoration: InputDecoration(
                            hintText: "Enter Your School/University",
                            hintStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            label: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 9),
                                child: Text("School/University")),
                            suffixIcon: InkWell(
                                child: Icon(Icons.business), onTap: () {}),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          //  decoration: InputDecoration(labelText: 'Company'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        TextFormField(
                          controller: controller.descriptionController,
                          maxLines: null, // Allow multiple lines
                          keyboardType: TextInputType.multiline,

                          decoration: InputDecoration(
                            hintText: "Enter the Description",
                            hintStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            label: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 9),
                                child: Text("Description")),
                            suffixIcon: InkWell(
                                child: Icon(Icons.description), onTap: () {}),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          //  decoration: InputDecoration(labelText: 'Description'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        TextFormField(
                          controller: controller.startDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Enter the Start Date",
                            hintStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            label: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 9),
                                child: Text("Start Date")),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.date_range),
                              onPressed: () =>
                                  controller.pickStartDate(context),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.endDateController,
                                readOnly: !controller.isSaveVisible.value,
                                decoration: InputDecoration(
                                  hintText: "Enter the End Date",
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 30),
                                  label: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 9),
                                      child: Text("End Date")),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.date_range),
                                    onPressed: controller.isSaveVisible.value
                                        ? () => controller.pickEndDate(context)
                                        : null,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                validator: controller.isSaveVisible.value
                                    ? (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Field cannot be empty';
                                        }
                                        return null;
                                      }
                                    : null,
                              ),
                            ),
                            Checkbox(
                              value: controller.isSaveVisible.value,
                              onChanged: (value) {
                                controller.isSaveVisible.value = value!;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              onPressed: controller.saveEducation,
                              color: Color.fromARGB(255, 85, 191, 218),
                              textColor: Colors.white,
                              child: Text('Save'),
                            ),
                            SizedBox(width: 8),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              onPressed: controller.undoEducation,
                              color: Color.fromARGB(255, 85, 191, 218),
                              textColor: Colors.white,
                              child: Text('Undo'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 16),
              Text(
                'Education Level List:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildExperienceList(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceList(EducationController controller) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: controller.educationLevels.asMap().entries.map((entry) {
          final index = entry.key;
          final education = entry.value;

          return Column(
            children: [
              ListTile(
                title: Text('Specialty: ${education['Specialty']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('School: ${education['School']}'),
                    Text('Description: ${education['Description']}'),
                    Text('Start Date: ${education['Start Date']}'),
                    Text('End Date: ${education['End Date']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => controller.editEducation(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.removeEducation(index),
                    ),
                  ],
                ),
              ),
              if (index < controller.educationLevels.length - 1)
                Divider(
                  color: Color.fromARGB(255, 194, 193, 193),
                  thickness: 1.5,
                ),
            ],
          );
        }).toList(),
      );
    });
  }
}
