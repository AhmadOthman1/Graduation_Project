import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/groupTrello_controller.dart';
import 'package:growify/controller/home/tasks_controller/tasks_controller.dart';
import 'package:growify/view/screen/homescreen/Groups/TrelloGroup/trellodescription.dart';
import 'package:growify/view/screen/homescreen/Groups/TrelloGroup/trellotask.dart';
import 'package:intl/intl.dart'; // Import the intl package


class GroupTrelloHomePage extends StatefulWidget {
  const GroupTrelloHomePage({super.key});

  @override
  _GroupTrelloHomePageState createState() => _GroupTrelloHomePageState();
}

class _GroupTrelloHomePageState extends State<GroupTrelloHomePage> {
  GlobalKey<FormState>formstate=GlobalKey();
  late List<TaskGroup> tasks = [
    TaskGroup(
      'Default Task 1',
      'This is the description for Default Task 1.',
      const TimeOfDay(hour: 8, minute: 0),
      const TimeOfDay(hour: 9, minute: 30),
      DateTime(2023, 12, 18),
      DateTime(2023, 12, 18, 12, 0),
      'ToDo',
    ),
    TaskGroup(
      'Default Task 2',
      'This is the description for Default Task 2.',
      const TimeOfDay(hour: 10, minute: 0),
      const TimeOfDay(hour: 12, minute: 0),
      DateTime(2023, 12, 19),
      DateTime(2023, 12, 19, 15, 0),
      'Doing',
    ),
    TaskGroup(
      'Default Task 3',
      'This is the description for Default Task 3.',
      const TimeOfDay(hour: 14, minute: 0),
      const TimeOfDay(hour: 15, minute: 30),
      DateTime(2023, 12, 20),
      DateTime(2023, 12, 20, 18, 0),
      'Done',
    ),
  ];

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? startDate;
  DateTime? endDate;

 void _addTask() async {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final result = await showDialog<TaskGroup>(
    context: context,
    builder: (BuildContext context) {
      TextEditingController taskNameController = TextEditingController();
      TextEditingController descriptionController = TextEditingController();
      GroupTrelloController controller = Get.put(GroupTrelloController());

      return AlertDialog(
        title: const Text('Add Task'),
        contentPadding: const EdgeInsets.all(16.0),
        content: SingleChildScrollView(
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
                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                const SizedBox(height: 30),
                TextFormField(
                  maxLines: 6,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "Enter Your Description",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: const Text('Start:'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
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
                          initialTime: startTime ?? TimeOfDay.now(),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: const Text('End:'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: endDate ?? DateTime.now(),
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
                          initialTime: endTime ?? TimeOfDay.now(),
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
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (endDate != null && startDate != null) {
                  if (endDate!.isBefore(startDate!)) {
                    // Show an error message
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('End date cannot be earlier than the start date'),
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

                  if (endDate!.isAtSameMomentAs(startDate!) && endTime != null && startTime != null) {
                    if (endTime!.hour < startTime!.hour ||
                        (endTime!.hour == startTime!.hour && endTime!.minute < startTime!.minute)) {
                      // Show an error message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('End time cannot be earlier than the start time'),
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

                Navigator.pop(
                  context,
                  TaskGroup(
                    taskNameController.text,
                    descriptionController.text,
                    startTime ?? const TimeOfDay(hour: 0, minute: 0),
                    endTime ?? const TimeOfDay(hour: 0, minute: 0),
                    startDate ?? DateTime.now(),
                    endDate ?? DateTime.now(),
                    'ToDo', // Set initial status as ToDo
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
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




  void _goToDescriptionPage(TaskGroup task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDescriptionPage(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Trello'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ToDo'),
              Tab(text: 'Doing'),
              Tab(text: 'Done'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildTab('ToDo'),
            buildTab('Doing'),
            buildTab('Done'),
          ],
        ),
      ),
    );
  }

  Widget buildTab(String status) {
    List<TaskGroup> filteredTasks =
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
                    items:
                        <String>['ToDo', 'Doing', 'Done'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          filteredTasks[index].status = newValue;
                        });
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

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
