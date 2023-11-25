import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeeAboutInfoController extends GetxController {

  final RxList<Map<String, String>> personalData =
      <Map<String, String>>[
    {
      'Specialty': 'Obaida Aws',
      'Company': 'ABC Tech',
      'Description': 'Developing awesome apps',
      'Start Date': '2022-01-01',
      'End Date': '2022-12-31',
    },
 
  ].obs;
  



}