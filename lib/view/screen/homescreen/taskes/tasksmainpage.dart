import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/tasks_controller/tasks_controller.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'description.dart';
import 'task.dart';

class TasksHomePage extends StatefulWidget {
  const TasksHomePage({super.key});

  @override
  _TasksHomePageState createState() => _TasksHomePageState();
}

TasksController controller = Get.put(TasksController());

class _TasksHomePageState extends State<TasksHomePage> {
  GlobalKey<FormState> formstate = GlobalKey();

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TimeOfDay? reminderTime;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? reminderDate;
  bool isSaveVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _addTask() async {
    var selectedStatus = 'ToDo';
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final result = await showDialog<Task>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController taskNameController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Task'),
          contentPadding: const EdgeInsets.all(15.0),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: taskNameController,
                              decoration: InputDecoration(
                                hintText: "Enter Your Task Name",
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 30,
                                ),
                                labelText: "Task Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a task name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              maxLines: 6,
                              controller: descriptionController,
                              decoration: InputDecoration(
                                hintText: "Enter Your Description",
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 30,
                                ),
                                labelText: "Description",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Text('Status:'),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    height: 60,
                                    child: DropdownButtonFormField<String>(
                                      value: selectedStatus,
                                      items: [
                                        'ToDo',
                                        'Doing',
                                        'Done',
                                        'Archived'
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            selectedStatus = newValue;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(right: 2),
                                      child: const Text(
                                        'Start:',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              startDate ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          setState(() {
                                            startDate = pickedDate;
                                          });
                                        }
                                      },
                                      child: const Text('Select Date'),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime:
                                              startTime ?? TimeOfDay.now(),
                                        );
                                        if (pickedTime != null) {
                                          setState(() {
                                            startTime = pickedTime;
                                          });
                                        }
                                      },
                                      child: const Text('Select Time'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (startDate != null && startTime != null)
                              Row(
                                children: [
                                  const Text('Selected Start: '),
                                  Text(
                                    '${_formatDate(startDate!)} , ${startTime!.format(context)}',
                                  ),
                                ],
                              ),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(right: 2),
                                      child: const Text(
                                        'End:   ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              endDate ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          setState(() {
                                            endDate = pickedDate;
                                          });
                                        }
                                      },
                                      child: const Text('Select Date'),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime:
                                              endTime ?? TimeOfDay.now(),
                                        );
                                        if (pickedTime != null) {
                                          setState(() {
                                            endTime = pickedTime;
                                          });
                                        }
                                      },
                                      child: const Text('Select Time'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (endDate != null && endTime != null)
                              Row(
                                children: [
                                  const Text('Selected End: '),
                                  Text(
                                    '${_formatDate(endDate!)} , ${endTime!.format(context)}',
                                  ),
                                ],
                              ),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  margin: const EdgeInsets.only(right: 20),
                                  child: const Text(
                                    'Remind Me : ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed: () async {
                                        final pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              reminderDate ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          setState(() {
                                            reminderDate = pickedDate;
                                          });
                                        }
                                      },
                                      child: const Text('Select Date'),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime:
                                              reminderTime ?? TimeOfDay.now(),
                                        );
                                        if (pickedTime != null) {
                                          setState(() {
                                            reminderTime = pickedTime;
                                          });
                                        }
                                      },
                                      child: const Text('Select Time'),
                                    ),
                                    //
                                    Checkbox(
                                      value: isSaveVisible,
                                      onChanged: (value) {
                                        setState(() {
                                          isSaveVisible = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (reminderDate != null && reminderTime != null)
                              Row(
                                children: [
                                  const Text('Selected Reminder: '),
                                  Text(
                                    '${_formatDate(reminderDate!)} , ${reminderTime!.format(context)}',
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (endDate != null && startDate != null) {
                              if (endDate!.isBefore(startDate!)) {
                                // Show an error message
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'End date cannot be earlier than the start date'),
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
                                return;
                              }

                              if (endDate!.isAtSameMomentAs(startDate!) &&
                                  endTime != null &&
                                  startTime != null) {
                                if (endTime!.hour < startTime!.hour ||
                                    (endTime!.hour == startTime!.hour &&
                                        endTime!.minute < startTime!.minute)) {
                                  // Show an error message
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Error'),
                                        content: const Text(
                                            'End time cannot be earlier than the start time'),
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
                                  return;
                                }
                              }
                            }

                            if (isSaveVisible) {
                              // Check if reminderDate or reminderTime is null
                              if (reminderDate == null ||
                                  reminderTime == null) {
                                // Show an error message
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Reminder not selected'),
                                      content: const Text(
                                          'Please select reminder date and time'),
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
                                return;
                              }
                            }

                            if (taskNameController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty &&
                                startTime != null &&
                                endTime != null &&
                                startDate != null &&
                                endDate != null &&
                                selectedStatus != null) {
                              var task = Task(
                                taskNameController.text,
                                descriptionController.text,
                                startTime ??
                                    const TimeOfDay(hour: 0, minute: 0),
                                endTime ?? const TimeOfDay(hour: 0, minute: 0),
                                startDate ?? DateTime.now(),
                                endDate ?? DateTime.now(),
                                selectedStatus,
                                isSaveVisible ? reminderDate : null,
                                isSaveVisible ? reminderTime : null,
                              );
                              var newTaskId =
                                  await controller.createUserTask(task);
                              BuildContext localContext = context;
                              if (newTaskId != null) {
                                Navigator.pop(localContext, task);
                              }
                            }
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    // Update the buttons directly when TimePicker is confirmed
    setState(() {
      if (result != null) {
        tasks.add(result);
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  void _goToDescriptionPage(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DescriptionPage(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Replace this with your actual future operation
        future: controller.initUserTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Return a loading indicator while waiting for the future to complete
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Handle any errors that occurred during the initialization
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('My Tasks'),
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'ToDo'),
                      Tab(text: 'Doing'),
                      Tab(text: 'Done'),
                      Tab(text: 'Archived'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    buildTab('ToDo'),
                    buildTab('Doing'),
                    buildTab('Done'),
                    buildTab('Archived'),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget buildTab(String status) {
    List<Task> filteredTasks =
        tasks.where((task) => task.status == status).toList();

    return Scaffold(
      body: filteredTasks.isEmpty
          ? const Center(child: Text('No tasks yet.'))
          : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(filteredTasks[index].taskName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start: ${_formatDate(filteredTasks[index].startDate)}, ${filteredTasks[index].startTime.format(context)}',
                      ),
                      Text(
                        'End: ${_formatDate(filteredTasks[index].endDate)}, ${filteredTasks[index].endTime.format(context)}',
                      ),
                    ],
                  ),
                  trailing: DropdownButton<String>(
                    value: filteredTasks[index].status,
                    items: <String>[
                      'ToDo',
                      'Doing',
                      'Done',
                      'Archived',
                      'Delete'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      if (newValue != null) {
                        var result = await controller.changeUserTaskStatus(
                            filteredTasks[index], newValue);
                        if (result && newValue != 'Delete') {
                          filteredTasks[index].status = newValue;
                          setState(() {});
                        }
                        if (result && newValue == 'Delete') {
                          filteredTasks[index].status = newValue;
                          setState(() {
                            // Remove the task from filteredTasks if the status is 'Delete'
                            filteredTasks
                                .removeWhere((task) => task.status == 'Delete');
                          });
                        }
                      }
                    },
                  ),
                  onTap: () {
                    _goToDescriptionPage(filteredTasks[index]);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
