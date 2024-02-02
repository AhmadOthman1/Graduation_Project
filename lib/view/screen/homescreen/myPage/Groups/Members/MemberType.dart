import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/Members/AddEmployeeMember.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/Members/AddOtherMember.dart';

class MemberType extends StatelessWidget {
  final pageId;
  final groupId;
  MemberType({super.key, this.pageId, this.groupId});

  @override
  Widget build(BuildContext context) {
      if (kIsWeb) {
        return Scaffold(
      appBar: AppBar(
        title: Text("Add New Member"),
      ),
      body: Column(
        children: [
          
          const Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Row(
            children: [
               Expanded(
                flex: 3,
                child: Container(),
              ),
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
                          offset:
                              Offset(0, 3), // changes the position of shadow
                        ),
                      ],
                    ),
                  child: Column(
                    children: [
                     
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        child: InkWell(
                          onTap: () {
                            Get.to(AddEmployeeMember(pageId:pageId,groupId:groupId));
                          },
                          child: Container(
                            height: 35,
                            padding: const EdgeInsets.only(left: 10),
                            child: const Row(
                              children: [
                                Icon(Icons.group_rounded),
                                SizedBox(width: 10),
                                Text(
                                  "Internal Employee Addition",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward, size: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 194, 193, 193),
                        thickness: 2.0,
                      ),
                       Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        child: InkWell(
                          onTap: () {
                     Get.to(AddMember(pageId:pageId,groupId:groupId));
                          },
                          child: Container(
                            height: 35,
                            padding: const EdgeInsets.only(left: 10),
                            child: const Row(
                              children: [
                                Icon(Icons.group_rounded),
                                SizedBox(width: 10),
                                Text(
                                  "External Member Invitation",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward, size: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 194, 193, 193),
                        thickness: 2.0,
                      ),
                      
                      
                      
                    ],
                  ),
                ),
              ),

               Expanded(
                flex: 3,
                child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
        
      }else{

        return Scaffold(
      appBar: AppBar(
        title: Text("Add New Member"),
      ),
      body: Column(
        children: [
          
          const Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Column(
            children: [
             
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: InkWell(
                  onTap: () {
                    Get.to(AddEmployeeMember(pageId:pageId,groupId:groupId));
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.group_rounded),
                        SizedBox(width: 10),
                        Text(
                          "Internal Employee Addition",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward, size: 30),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 194, 193, 193),
                thickness: 2.0,
              ),
               Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: InkWell(
                  onTap: () {
             Get.to(AddMember(pageId:pageId,groupId:groupId));
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.group_rounded),
                        SizedBox(width: 10),
                        Text(
                          "External Member Invitation",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward, size: 30),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 194, 193, 193),
                thickness: 2.0,
              ),
              
              
              
            ],
          ),
        ],
      ),
    );

      }
  }
}
