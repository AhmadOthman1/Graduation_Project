import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> alertExitApp() {
   Get.defaultDialog(
      title: "Alert",
      middleText: " Exit the app ? ",
      actions: [
        TextButton(onPressed: () {
          exit(0);
        }, child: Text("Confirm")),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Cancel"))
      ]);
    
      return Future.value(true);
}
