import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'task.dart';

class DescriptionPage extends StatelessWidget {
  final Task task;

  DescriptionPage({required this.task});

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Name: ${task.taskName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${task.description}',
            ),
            SizedBox(height: 10),
            Text(
              'Status: ${task.status}',
            ),
            SizedBox(height: 10),
            Text(
              '${_formatDate(task.startDate)} ${task.startTime.format(context)} - ${_formatDate(task.endDate)} ${task.endTime.format(context)}',
            ),
          ],
        ),
      ),
    );
  }
}
