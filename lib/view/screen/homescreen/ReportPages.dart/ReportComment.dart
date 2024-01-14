import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Report_Controller.dart/ReportComment_controller.dart';

class ReportCommentPage extends StatefulWidget {
  final commentId;

  ReportCommentPage({this.commentId});

  @override
  _ReportCommentPageState createState() => _ReportCommentPageState();
}

class _ReportCommentPageState extends State<ReportCommentPage> {
  final TextEditingController reportController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ReportCommentController controller = Get.put(ReportCommentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report The Comment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: reportController, // Add this line
                onChanged: (value) {
                  // Do something with the onChanged value
                },
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Enter your report',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  labelText: 'Report',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your report';
                  }
                  return null;
                },
              ),
              SizedBox(height: 60),
              Container(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      print('Comment ID: ${widget.commentId}');
                      print('Report: ${reportController.text}');
                      controller.ReportComment(widget.commentId, reportController.text);
                      // Add the logic to post the report here
                      // Get.back();
                    }
                  },
                  color: const Color.fromARGB(255, 85, 191, 218),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Send",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
