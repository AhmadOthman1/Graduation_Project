import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/controller/home/workexperience_controller.dart';
import 'package:growify/view/screen/homescreen/taskes/tasksmainpage.dart';

class WorkExperience extends StatelessWidget {
  final ExperienceController controller = Get.put(ExperienceController());
  late HomePageControllerImp HPcontroller = Get.put(HomePageControllerImp());
  WorkExperience({super.key});
  ImageProvider<Object> avatarImage =
      const AssetImage("images/profileImage.jpg");
  String name =
      GetStorage().read("firstname") + " " + GetStorage().read("lastname");
  final LogOutButtonControllerImp logoutController =
      Get.put(LogOutButtonControllerImp());
  @override
  Widget build(BuildContext context) {
    // store data from the database in my array by use setPracticalExperiences function
    var args = Get.arguments;
    List<Map<String, String>> workExperiences =
        args != null ? args['workExperiences'] : [];

    controller.setPracticalExperiences(workExperiences);
    controller.undoExperience();

    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Work Experience",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 2, child: Container()),
            Expanded(
              flex: 4,
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.topCenter,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(
                                  0, 3), // changes the position of shadow
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 13, horizontal: 15),
                                  onPressed: controller.addNewExperience,
                                  color:
                                      const Color.fromARGB(255, 85, 191, 218),
                                  textColor: Colors.white,
                                  child: const Text('Add New Experience'),
                                ),
                                const SizedBox(height: 16),
                                Obx(() {
                                  return Visibility(
                                    visible:
                                        controller.isAddingExperience.value,
                                    child: Form(
                                      key: controller.experienceFormKey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller:
                                                controller.specialtyController,
                                            decoration: InputDecoration(
                                              hintText: "Enter Your Specialty",
                                              hintStyle: const TextStyle(
                                                fontSize: 14,
                                              ),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 30),
                                              label: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 9),
                                                  child:
                                                      const Text("Specialty")),
                                              suffixIcon: InkWell(
                                                  child: const Icon(
                                                      Icons.work_history_sharp),
                                                  onTap: () {}),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Field cannot be empty';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller:
                                                controller.companyController,

                                            decoration: InputDecoration(
                                              hintText: "Enter Your Company",
                                              hintStyle: const TextStyle(
                                                fontSize: 14,
                                              ),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 30),
                                              label: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 9),
                                                  child: const Text("Company")),
                                              suffixIcon: InkWell(
                                                  child: const Icon(
                                                      Icons.business),
                                                  onTap: () {}),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            //  decoration: InputDecoration(labelText: 'Company'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Field cannot be empty';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 13,
                                          ),
                                          TextFormField(
                                            controller: controller
                                                .descriptionController,
                                            maxLines:
                                                null, // Allow multiple lines
                                            keyboardType:
                                                TextInputType.multiline,

                                            decoration: InputDecoration(
                                              hintText: "Enter the Description",
                                              hintStyle: const TextStyle(
                                                fontSize: 14,
                                              ),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 30),
                                              label: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 9),
                                                  child: const Text(
                                                      "Description")),
                                              suffixIcon: InkWell(
                                                  child: const Icon(
                                                      Icons.description),
                                                  onTap: () {}),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            //  decoration: InputDecoration(labelText: 'Description'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Field cannot be empty';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 13,
                                          ),
                                          TextFormField(
                                            controller:
                                                controller.startDateController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              hintText: "Enter the Start Date",
                                              hintStyle: const TextStyle(
                                                fontSize: 14,
                                              ),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 30),
                                              label: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 9),
                                                  child:
                                                      const Text("Start Date")),
                                              suffixIcon: IconButton(
                                                icon: const Icon(
                                                    Icons.date_range),
                                                onPressed: () => controller
                                                    .pickStartDate(context),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Field cannot be empty';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 13,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller: controller
                                                      .endDateController,
                                                  readOnly: !controller
                                                      .isSaveVisible.value,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Enter the End Date",
                                                    hintStyle: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 15,
                                                            horizontal: 30),
                                                    label: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 9),
                                                        child: const Text(
                                                            "End Date")),
                                                    suffixIcon: IconButton(
                                                      icon: const Icon(
                                                          Icons.date_range),
                                                      onPressed: controller
                                                              .isSaveVisible
                                                              .value
                                                          ? () => controller
                                                              .pickEndDate(
                                                                  context)
                                                          : null,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                  ),
                                                  validator: controller
                                                          .isSaveVisible.value
                                                      ? (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Field cannot be empty';
                                                          }
                                                          return null;
                                                        }
                                                      : null,
                                                ),
                                              ),
                                              Checkbox(
                                                value: controller
                                                    .isSaveVisible.value,
                                                onChanged: (value) {
                                                  controller.isSaveVisible
                                                      .value = value!;
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 13),
                                                onPressed:
                                                    controller.saveExperience,
                                                color: const Color.fromARGB(
                                                    255, 85, 191, 218),
                                                textColor: Colors.white,
                                                child: const Text('Save'),
                                              ),
                                              const SizedBox(width: 8),
                                              MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 13),
                                                onPressed:
                                                    controller.undoExperience,
                                                color: const Color.fromARGB(
                                                    255, 85, 191, 218),
                                                textColor: Colors.white,
                                                child: const Text('Undo'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 16),
                                const Text(
                                  'Experience List:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                _buildExperienceList(controller),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
            Expanded(
                      flex: 2,
                      child: Container(),
                    )
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Work Experience",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
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
                  color: const Color.fromARGB(255, 85, 191, 218),
                  textColor: Colors.white,
                  child: const Text('Add New Experience'),
                ),
                const SizedBox(height: 16),
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              label: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 9),
                                  child: const Text("Specialty")),
                              suffixIcon: InkWell(
                                  child: const Icon(Icons.work_history_sharp),
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
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: controller.companyController,

                            decoration: InputDecoration(
                              hintText: "Enter Your Company",
                              hintStyle: const TextStyle(
                                fontSize: 14,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              label: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 9),
                                  child: const Text("Company")),
                              suffixIcon: InkWell(
                                  child: const Icon(Icons.business),
                                  onTap: () {}),
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
                          const SizedBox(
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              label: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 9),
                                  child: const Text("Description")),
                              suffixIcon: InkWell(
                                  child: const Icon(Icons.description),
                                  onTap: () {}),
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
                          const SizedBox(
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              label: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 9),
                                  child: const Text("Start Date")),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.date_range),
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
                          const SizedBox(
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
                                        child: const Text("End Date")),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.date_range),
                                      onPressed: controller.isSaveVisible.value
                                          ? () =>
                                              controller.pickEndDate(context)
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
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                onPressed: controller.saveExperience,
                                color: const Color.fromARGB(255, 85, 191, 218),
                                textColor: Colors.white,
                                child: const Text('Save'),
                              ),
                              const SizedBox(width: 8),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                onPressed: controller.undoExperience,
                                color: const Color.fromARGB(255, 85, 191, 218),
                                textColor: Colors.white,
                                child: const Text('Undo'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                const Text(
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
                      icon: const Icon(Icons.edit),
                      onPressed: () => controller.editExperience(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => controller.removeExperience(index),
                    ),
                  ],
                ),
              ),
              if (index < controller.practicalExperiences.length - 1)
                const Divider(
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
