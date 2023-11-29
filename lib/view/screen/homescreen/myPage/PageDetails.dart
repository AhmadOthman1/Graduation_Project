import 'package:flutter/material.dart';
import 'package:growify/controller/home/myPage_Controller/PageDetails_controller.dart';

class PageDetails extends StatefulWidget {
  final String pageId;

  const PageDetails(this.pageId, {super.key});

  @override
  _PageDetailsState createState() => _PageDetailsState();
}

class _PageDetailsState extends State<PageDetails> {
  final PageDetailsController controller = PageDetailsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Pages",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Center(
        child: Text('Details for Page ID: ${widget.pageId}'),
      ),
    );
  }
}