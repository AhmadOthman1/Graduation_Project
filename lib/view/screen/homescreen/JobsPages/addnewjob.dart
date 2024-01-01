import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/JobsPage_Controller/newJob_controller.dart';



class NewJobPost extends StatelessWidget {
  NewJobPost({super.key});

  final NewJobControllerImp controller = Get.put(NewJobControllerImp());
  GlobalKey<FormState> formstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: GetBuilder<NewJobControllerImp>(
          init: controller,
          builder: (controller) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: ListView(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 5, right: 15),
                          child: const Icon(
                            Icons.close,
                            size: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2, right: 15),
                        child: InkWell(
                          onTap: () {},
                          child: const CircleAvatar(
                            backgroundImage: AssetImage(
                              'images/obaida.jpeg',
                            ),
                            radius: 20,
                          ),
                        ),
                      ),
                      
                      const Spacer(),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () async {
                          if (formstate.currentState!.validate()) {
                         /*   var message = await controller.postJob();
                            (message != null)
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomAlertDialog(
                                        title: 'Error',
                                        icon: Icons.error,
                                        text: message,
                                        buttonText: 'OK',
                                      );
                                    },
                                  )
                                : null;*/
                          }
                        },
                        child: const Text(
                          "Post",
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: formstate,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) =>
                              controller.postContent.value = value,
                          decoration: const InputDecoration(
                            hintText: 'What job do you want to advertise?',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 145),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null &&
                                picked != controller.endDate.value) {
                              controller.updateEndDate(picked);
                            }
                          },
                          child: const Text('Select End Date'),
                        ),
                      ],
                    ),
                  ),
                  
                  
                 
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
