import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/workexperience_controller.dart';

class WorkExperience extends StatelessWidget {
  final ExperienceController controller = Get.put(ExperienceController());



  @override
  Widget build(BuildContext context) {

    // store data from the database in my array by use setPracticalExperiences function
                  var args = Get.arguments;
    List<Map<String, String>> workExperiences =
        args != null ? args['workExperiences'] : [];

        controller.setPracticalExperiences(workExperiences);

    
 

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Work Experience",
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
                onPressed: controller.addNewExperience,
                color: Color.fromARGB(255, 85, 191, 218),
                textColor: Colors.white,
                child: Text('Add New Experience'),
              ),
              SizedBox(height: 16),
              Obx(() {
                return Visibility(
                  visible: controller.isAddingExperience.value,
                  child: Form(
                    key: controller.experienceFormKey,
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
                          controller: controller.companyController,

                          decoration: InputDecoration(
                            hintText: "Enter Your Company",
                            hintStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            label: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 9),
                                child: Text("Company")),
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
                              onPressed: controller.saveExperience,
                              color: Color.fromARGB(255, 85, 191, 218),
                              textColor: Colors.white,
                              child: Text('Save'),
                            ),
                            SizedBox(width: 8),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              onPressed: controller.undoExperience,
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
                'Experience List:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildExperienceList(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceList(ExperienceController controller) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: controller.practicalExperiences.asMap().entries.map((entry) {
          final index = entry.key;
          final experience = entry.value;


          return Column(
            children: [
              ListTile(
                title: Text('Specialty: ${experience['Specialty']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Company: ${experience['Company']}'),
                    Text('Description: ${experience['Description']}'),
                    Text('Start Date: ${experience['Start Date']}'),
                    Text('End Date: ${experience['End Date']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => controller.editExperience(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.removeExperience(index),
                    ),
                  ],
                ),
              ),
              if (index < controller.practicalExperiences.length - 1)
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
