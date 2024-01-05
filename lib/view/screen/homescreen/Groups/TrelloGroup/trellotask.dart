import 'package:flutter/material.dart';

class TaskGroup {
  final String taskName;
  final String description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final DateTime startDate; // Added field for start date
  final DateTime endDate; // Added field for end date
  String status; 

  TaskGroup(
    this.taskName,
    this.description,
    this.startTime,
    this.endTime,
    this.startDate, // Updated constructor to include start date
    this.endDate, // Updated constructor to include end date
    this.status,
  );
}
