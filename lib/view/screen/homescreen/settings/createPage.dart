import 'package:flutter/material.dart';
import 'package:growify/controller/home/createPage_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/core/functions/validinput.dart';
import 'package:growify/view/widget/auth/textFormAuth.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String? pageId;
  final CreatePageController controller = CreatePageController();
  GlobalKey<FormState> formstate = GlobalKey();

  // Define controllers for text fields
  final TextEditingController _pageIdController = TextEditingController();
  final TextEditingController _pageNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _CountryController = TextEditingController();
  final TextEditingController _AddressController = TextEditingController();
  final TextEditingController _ContactInfoController = TextEditingController();
  final TextEditingController _SpecialityController = TextEditingController();
  final TextEditingController _PageTypeController = TextEditingController();
  // Add controllers for other fields...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formstate,
          child: ListView(
            children: [
              Container(
                height: 20,
              ),
              TextFormAuth(
                valid: (value) {
                  pageId = value;
                  return validInput(value!, 50, 5, "username");
                },
                mycontroller: _pageIdController,
                hinttext: "Enter a unique page id",
                labeltext: "Page id ",
                iconData: Icons.person_outlined,
              ),
              TextFormAuth(
                valid: (value) {
                  pageId = value;
                  return validInput(value!, 50, 1, "username");
                },
                mycontroller: _pageNameController,
                hinttext: "Enter a unique page name",
                labeltext: "Page Name ",
                iconData: Icons.person_outlined,
              ),
              TextFormAuth(
                valid: (value) {
                  pageId = value;
                  return validInput(value!, 2000, 1, "length");
                },
                mycontroller: _descriptionController,
                hinttext: "Enter Your page description",
                labeltext: "Description",
                iconData: Icons.person_outlined,
              ),
              TextFormAuth(
                valid: (value) {
                  pageId = value;
                  return validInput(value!, 50, 1, "length");
                },
                mycontroller: _CountryController,
                hinttext: "Enter Your page country",
                labeltext: "Country",
                iconData: Icons.person_outlined,
              ),
              TextFormAuth(
                valid: (value) {
                  pageId = value;
                  return validInput(value!, 2000, 1, "length");
                },
                mycontroller: _AddressController,
                hinttext: "Enter Your page address",
                labeltext: "Address",
                iconData: Icons.person_outlined,
              ),
              TextFormAuth(
                valid: (value) {
                  pageId = value;
                  return validInput(value!, 2000, 1, "length");
                },
                mycontroller: _ContactInfoController,
                hinttext: "Enter Your page contact Info",
                labeltext: "ContactInfo",
                iconData: Icons.person_outlined,
              ),
              // Add other TextFormField widgets for other fields...
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 135),
                onPressed: () async {
                  if (formstate.currentState!.validate()) {
                    var message = await controller.createPage(
                      pageId: _pageIdController.text,
                      pageName: _pageNameController.text,
                      description: _descriptionController.text,
                      country: _CountryController.text,
                      address: _AddressController.text,
                      contactInfo: _ContactInfoController.text,
                      speciality: _SpecialityController.text,
                      pageType: _PageTypeController.text,
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
                  }
                },
                color: Color.fromARGB(255, 85, 191, 218),
                textColor: Colors.white,
                child: Text("Save Changes"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formstate.currentState!.validate()) {
                    // Call the function to create the page
                    controller.createPage(
                      pageId: _pageIdController.text,
                      pageName: _pageNameController.text,
                      description: _descriptionController.text,
                      country: _CountryController.text,
                      address: _AddressController.text,
                      contactInfo: _ContactInfoController.text,
                      speciality: _SpecialityController.text,
                      pageType: _PageTypeController.text,
                      // Include other parameters...
                    );
                  }
                },
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
