import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'taskGroup.dart';

class DescriptionGroupPage extends StatelessWidget {
  final Task task;

  const DescriptionGroupPage({super.key, required this.task});

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${task.taskName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding:
                  EdgeInsets.only(left: 8.0), // Adjust the padding as needed
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.grey, // Set your desired border color
                    width: 2.0, // Set your desired border width
                  ),
                ),
              ),
              child: Text(
                '${task.description}',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'user: ${task.username}',
            ),const SizedBox(height: 10),
            Text(
              'Status: ${task.status}',
            ),
            const SizedBox(height: 10),
            Text(
              '${_formatDate(task.startDate)} ${task.startTime.format(context)} - ${_formatDate(task.endDate)} ${task.endTime.format(context)}',
            ),
          ],
        ),
      ),
    );
  }
}
