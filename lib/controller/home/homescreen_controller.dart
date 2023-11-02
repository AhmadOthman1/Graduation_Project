import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/homepages/homemainPage.dart';
import 'package:growify/view/screen/homescreen/Networkspages/networkmainpage.dart';
import 'package:growify/view/screen/homescreen/JobsPages/jobsmainpage.dart';
import 'package:growify/view/screen/homescreen/notificationspages/notificationmainpage.dart';

abstract class HomeScreeenController extends GetxController{

changePage(int currentpage);

}

class HomeScreenControllerImp extends HomeScreeenController{

  int currentpage=0;

  List<Widget>listPage=[

     Homepage(),
     NotificationsPage(),
   JobsPage(),

   NetworksPage()

  ];

  List titlebottomappbar=[
    "Home",
    "Notices",
    "Jobs",
    "Networks",
    
    
  ];

  List<IconData> icons = [
    Icons.home,
    Icons.notifications,
    Icons.work,
    Icons.diversity_3,
    
    
  ];
  @override
  changePage(int indexofpage) {


    currentpage=indexofpage;
    update();
  
  }

}