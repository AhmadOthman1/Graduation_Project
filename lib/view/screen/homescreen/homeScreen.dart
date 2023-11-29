import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/homescreen_controller.dart';
import 'package:growify/view/screen/homescreen/NewPost/newpost.dart';
import 'package:growify/view/widget/homePage/bottomappbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenControllerImp());
    return GetBuilder<HomeScreenControllerImp>(
        builder: (controller) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.to( NewPost());
              },
              child: const Icon(Icons.post_add_outlined),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape:const CircularNotchedRectangle(),
              notchMargin: 10,
              child: Row(
                children: [

                  ...List.generate(controller.titlebottomappbar.length+1,
                   ((index) {
                    int i=index>2?index-1:index;
                    return index==2 ? const Spacer() : BottommAppBar(
                          textbutton:controller.titlebottomappbar[i],
                          icondata: controller.icons[i],
                          onPressed: (){controller.changePage(i);},
                          active: controller.currentpage==i?true:false,
                          );
                   }))

                ],
              ),
            ),
            body: controller.listPage.elementAt(controller.currentpage)));
  }
}
