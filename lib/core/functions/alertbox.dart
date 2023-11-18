import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final String text;
  final String buttonText;

  const CustomAlertDialog({
    required this.title,
    required this.icon,
    required this.text,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(icon),
          SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(text),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Close the alert box
            Navigator.of(context).pop();
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
