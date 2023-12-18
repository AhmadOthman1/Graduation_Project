import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/trello_controller/trello_controller.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'description.dart';
import 'task.dart';

class TrelloHomePage extends StatefulWidget {
  @override
  _TrelloHomePageState createState() => _TrelloHomePageState();
}

class _TrelloHomePageState extends State<TrelloHomePage> {
  GlobalKey<FormState>formstate=GlobalKey();
  late List<Task> tasks = [
    Task(
      'Default Task 1',
      'This is the description for Default Task 1.',
      TimeOfDay(hour: 8, minute: 0),
      TimeOfDay(hour: 9, minute: 30),
      DateTime(2023, 12, 18),
      DateTime(2023, 12, 18, 12, 0),
      'ToDo',
    ),
    Task(
      'Default Task 2',
      'This is the description for Default Task 2.',
      TimeOfDay(hour: 10, minute: 0),
      TimeOfDay(hour: 12, minute: 0),
      DateTime(2023, 12, 19),
      DateTime(2023, 12, 19, 15, 0),
      'Doing',
    ),
    Task(
      'Default Task 3',
      'This is the description for Default Task 3.',
      TimeOfDay(hour: 14, minute: 0),
      TimeOfDay(hour: 15, minute: 30),
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
  final result = await showDialog<Task>(
    context: context,
    builder: (BuildContext context) {
      TextEditingController taskNameController = TextEditingController();
      TextEditingController descriptionController = TextEditingController();
      TrelloController controller = Get.put(TrelloController());

      return AlertDialog(
        title: Text('Add Task'),
        contentPadding: EdgeInsets.all(16.0),
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
                SizedBox(height: 30),
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Text('Start:'),
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
                      child: Text('Select Date'),
                    ),
                    SizedBox(
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
                      child: Text('Select Time'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Text('End:'),
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
                      child: Text('Select Date'),
                    ),
                    SizedBox(
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
                      child: Text('Select Time'),
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
                          title: Text('Error'),
                          content: Text('End date cannot be earlier than the start date'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
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
                            title: Text('Error'),
                            content: Text('End time cannot be earlier than the start time'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
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
                  Task(
                    taskNameController.text,
                    descriptionController.text,
                    startTime ?? TimeOfDay(hour: 0, minute: 0),
                    endTime ?? TimeOfDay(hour: 0, minute: 0),
                    startDate ?? DateTime.now(),
                    endDate ?? DateTime.now(),
                    'ToDo', // Set initial status as ToDo
                  ),
                );
              }
            },
            child: Text('Add'),
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Trello'),
          bottom: TabBar(
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
    List<Task> filteredTasks =
        tasks.where((task) => task.status == status).toList();

    return Scaffold(
      body: filteredTasks.isEmpty
          ? Center(child: Text('No tasks yet.'))
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
        child: Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
