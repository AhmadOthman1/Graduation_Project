import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/myPage_Controller/Admin_controller/ShowAdmin_controller.dart';
import 'package:growify/controller/home/myPage_Controller/Employee_Controller/ShowEmployee_controller.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/Admins/SelectAdmin.dart';
import 'package:growify/view/screen/homescreen/myPage/Employees/addEmployee.dart';

class ShowEmployees extends StatefulWidget {
  final pageId;
  const ShowEmployees({Key? key, required this.pageId}) : super(key: key);

  @override
  _ShowEmployeesState createState() => _ShowEmployeesState();
}

final ScrollController scrollController = ScrollController();

class _ShowEmployeesState extends State<ShowEmployees> {
  final NetworkMainPageControllerImp Networkcontroller =
      Get.put(NetworkMainPageControllerImp());
  late ShowEmployeesController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");

  @override
  void initState() {
    super.initState();
    _controller = ShowEmployeesController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadEmployees(_controller.page, widget.pageId);
      setState(() {
        _controller.page++;
        _controller.employees;
      });
      print('Data loaded: ${_controller.employees.length} employees');
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () {
                Get.off(AddEmployee(pageId: widget.pageId));
              },
              child: Text(
                "Edit Employees",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height - 50,
          child: Row(
            children: [
              Expanded(flex: 3, child: Container()),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes the position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _controller.employees.length,
                          itemBuilder: (context, index) {
                            final employee = _controller.employees[index];
                            final firstname = employee['firstname'];
                            final lastname = employee['lastname'];
                            final username = employee['username'];
                            final employeeFiled = employee['employeeField'];

                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    final userUsername = username;
                                    Networkcontroller.goToUserPage(
                                        userUsername!);
                                  },
                                  trailing: PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),
                                    onSelected: (String option) async {
                                      var message = await _controller
                                          .onMoreOptionSelected(
                                              option, username, widget.pageId);
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
                                      setState(() {});
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return _controller.moreOptions
                                          .map((String option) {
                                        return PopupMenuItem<String>(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList();
                                    },
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        (employee['photo'] != null &&
                                                employee['photo'] != "")
                                            ? Image.network("$urlStarter/" +
                                                    employee['photo']!)
                                                .image
                                            : defultprofileImage,
                                  ),
                                  title:
                                      Text('$firstname $lastname (@$username)'),
                                  subtitle: Text('$employeeFiled'),
                                ),
                                const Divider(
                                  color: Color.fromARGB(255, 194, 193, 193),
                                  thickness: 2.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      if (_controller.isLoading)
                        const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              Expanded(flex: 3, child: Container()),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () {
                Get.off(AddEmployee(pageId: widget.pageId));
              },
              child: Text(
                "Edit Employees",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const Divider(
              color: Color.fromARGB(255, 194, 193, 193),
              thickness: 2.0,
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _controller.employees.length,
                itemBuilder: (context, index) {
                  final employee = _controller.employees[index];
                  final firstname = employee['firstname'];
                  final lastname = employee['lastname'];
                  final username = employee['username'];
                  final employeeFiled = employee['employeeField'];

                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          final userUsername = username;
                          Networkcontroller.goToUserPage(userUsername!);
                        },
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String option) async {
                            var message =
                                await _controller.onMoreOptionSelected(
                                    option, username, widget.pageId);
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
                            setState(() {});
                          },
                          itemBuilder: (BuildContext context) {
                            return _controller.moreOptions.map((String option) {
                              return PopupMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList();
                          },
                        ),
                        leading: CircleAvatar(
                          backgroundImage: (employee['photo'] != null &&
                                  employee['photo'] != "")
                              ? Image.network(
                                      "$urlStarter/" + employee['photo']!)
                                  .image
                              : defultprofileImage,
                        ),
                        title: Text('$firstname $lastname (@$username)'),
                        subtitle: Text('$employeeFiled'),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 194, 193, 193),
                        thickness: 2.0,
                      ),
                    ],
                  );
                },
              ),
            ),
            if (_controller.isLoading) const CircularProgressIndicator(),
          ],
        ),
      );
    }
  }
}
