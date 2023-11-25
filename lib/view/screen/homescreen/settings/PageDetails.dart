import 'package:flutter/material.dart';

class PageDetails extends StatelessWidget {
  final String pageId;

  PageDetails(this.pageId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Pages",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Center(
        child: Text('Details for Page ID: $pageId'),
      ),
    );
  }
}