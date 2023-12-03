import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageProfile extends StatelessWidget {
  const PageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                    margin: const EdgeInsets.only(
                      top: 50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back, size: 30),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Al Qassam',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 180),
                      ],
                    ),
                  ),

                   const Divider(
              color: Color.fromARGB(255, 194, 193, 193),
              thickness: 2.0,
            ),


          ],
        ),
      ),
    );
  }



  
}