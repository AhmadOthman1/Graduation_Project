import 'package:flutter/material.dart';

class ChangeEmail extends StatelessWidget {
  const ChangeEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Email",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, 
        ),
      ),
    );
  }
}
