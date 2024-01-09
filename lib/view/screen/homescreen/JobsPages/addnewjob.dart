import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/myPage_Controller/JobsPage_Controller/newJob_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/chip_config.dart';
import 'package:multi_dropdown/models/network_config.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:multi_dropdown/widgets/hint_text.dart';
import 'package:multi_dropdown/widgets/selection_chip.dart';
import 'package:multi_dropdown/widgets/single_selected_item.dart';

class NewJobPost extends StatelessWidget {
  final pageId;
  final List<Map<String, dynamic>> availableFields;
  NewJobPost({super.key, required this.pageId, required this.availableFields});

  final NewJobControllerImp controller = Get.put(NewJobControllerImp());
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    controller.items.clear();
    controller.items = RxList<String>.from(
      availableFields.map<String>((map) => map['Field'].toString()),
    );
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
              child: Column(
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
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Add New Job',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: formstate,
                    child: Expanded(
                      child: ListView(
                        children: [
                          buildTextFormField(
                            hintText: 'Title',
                            onChanged: (value) => controller.updateTitle(value),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Container(
                            margin: EdgeInsets.only(left: 6),
                            child: Text("The Fields",style: TextStyle(color: Colors.grey),)),
                          MultiSelectDropDown(
                            searchEnabled: true,
                            onOptionSelected:
                                (List<ValueItem> selectedOptions) {
                                 controller.selectedItems.assignAll(selectedOptions.map((item) => item.value));
                                },
                            options: controller.items
                                .map((item) =>
                                    ValueItem(label: item, value: item))
                                .toList(),
                            selectionType: SelectionType.multi,
                            chipConfig:
                                const ChipConfig(wrapType: WrapType.scroll),
                            dropdownHeight: 300,
                            optionTextStyle: const TextStyle(fontSize: 16),
                            selectedOptionIcon: const Icon(Icons.check_circle),
                          ),
                          const SizedBox(height: 20),
                          buildTextFormField(
                            hintText: 'Description',
                            maxLines: 8,
                            onChanged: (value) =>
                                controller.updateDescription(value),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
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
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: const Text('Select End Date'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () async {
                        print("ooooooooooooooooooooooooooooooooooo");
                        print(controller.selectedItems);
                        if (formstate.currentState!.validate()) {
                          print('Title: ${controller.postTitle}');
                          print('Description: ${controller.postDescription}');
                          print('Selected Date: ${controller.endDate.value}');
                          var message = await controller.postJob(pageId);
                          (message != null)
                              ? await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomAlertDialog(
                                      title: 'Message',
                                      icon: Icons.error,
                                      text: message,
                                      buttonText: 'OK',
                                    );
                                  },
                                )
                              : null;
                              Get.back();
                        }
                      },
                      color: const Color.fromARGB(255, 85, 191, 218),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "Post",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
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

  Widget buildTextFormField({
    required String hintText,
    int? maxLines,
    required Function(String) onChanged,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 30,
        ),
        labelText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: validator,
    );
  }
}
