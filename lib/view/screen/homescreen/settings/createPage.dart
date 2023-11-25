import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:growify/controller/home/createPage_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/core/functions/validinput.dart';
import 'package:growify/view/widget/auth/textFormAuth.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String? pageId="";
  String? pageName="";
  String? description="";
  String? country="";
  String? address="";
  String? contactInfo="";
  String? speciality="";
  String? pageType="";
  final CreatePageController controller = CreatePageController();
  GlobalKey<FormState> formstate = GlobalKey();

  // Define controllers for text fields
  // Add controllers for other fields...
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Page",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formstate,
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                height: 20,
              ),
              TextFormAuth(
                valid: (value) {
                  return validInput(value!, 50, 5, "username");
                },
                onsaved: (val){
                  pageId = val;
                },
                hinttext: "Enter a unique page id",
                labeltext: "Page id ",
                iconData: Icons.person_outlined,
              ),
              TextFormAuth(
                valid: (value) {
                  return validInput(value!, 50, 1, "length");
                },
                onsaved: (val){
                  pageName = val;
                },
                hinttext: "Enter a unique page name",
                labeltext: "Page Name ",
                iconData: Icons.person_outlined,
              ),
              TextFormAuth(
                valid: (value) {
                  return validInput(value!, 2000, 1, "length");
                },
                onsaved: (val){
                  description = val;
                },
                hinttext: "Enter Your page description",
                labeltext: "Description",
                maxLines: 10,
                iconData: Icons.description,
              ),
              TextFormAuth(
                valid: (value) {
                  return validInput(value!, 2000, 1, "length");
                },
                onsaved: (val){
                  address = val;
                },
                hinttext: "Enter Your page address",
                labeltext: "Address",
                maxLines: 10,
                iconData: Icons.location_city,
              ),
              
              TextFormAuth(
                valid: (value) {
                  return validInput(value!, 2000, 1, "length");
                },
                onsaved: (val){
                  contactInfo = val;
                },
                hinttext: "Enter Your page contact Info",
                maxLines: 10,
                labeltext: "ContactInfo",
                iconData: Icons.contacts_outlined,
              ),
              TextFormAuth(
                valid: (value) {
                  return validInput(value!, 2000, 1, "length");
                },
                onsaved: (val){
                  speciality = val;
                },
                hinttext: "Enter Your page Speciality",
                labeltext: "Speciality",
                maxLines: 10,
                iconData: Icons.build,
              ),
              Container(
                height: 20,
              ),
              Obx(
                () => Row(
                  children: [
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(right: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            label: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 9),
                              child: Text("Your Country"),
                            ),
                          ),
                          isExpanded: true,
                          hint: Text('Select Country',
                              style: TextStyle(color: Colors.grey)),
                          items: controller.countryList.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: controller.country.value.isEmpty
                              ? null
                              : controller.country.value,
                          onChanged: (value) {
                            controller.country.value = value.toString();
                            print(controller.country.value);
                          }, // Disable the dropdown when not enabled
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select country';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 20,
              ),
              Obx(
                () => Row(
                  children: [
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(right: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            label: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 9),
                              child: Text("Your field of Page Type"),
                            ),
                          ),
                          isExpanded: true,
                          hint: Text('Select Page Type',
                              style: TextStyle(color: Colors.grey)),
                          items: controller.PageTypeList.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: controller.PageType.value.isEmpty
                              ? null
                              : controller.PageType.value,
                          onChanged: (value) {
                            controller.PageType.value = value.toString();
                            print(controller.PageType.value);
                          }, // Disable the dropdown when not enabled
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select Page Type';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 20,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 135),
                onPressed: () async {
                  if (!formstate.currentState!.validate()) {
                    return;
                  }

                  formstate.currentState!.save();

                  var message = await controller.createPage(
                      pageId: pageId,
                      pageName: pageName,
                      description: description,
                      address: address,
                      contactInfo: contactInfo,
                      country: controller.country.value,
                      speciality: speciality,
                      pageType: controller.PageType.value,
                      // Include other parameters...
                    );
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
                        : null;
                },
                color: Color.fromARGB(255, 85, 191, 218),
                textColor: Colors.white,
                child: Text("Save Changes"),
              ),
            ],
            )
          ),
        ),
      ),
    );
  }
}
