import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/view/widget/homePage/comments.dart';

class CommentsMainPage extends StatelessWidget {
  const CommentsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments"),),
      body: Comments(),
         
        

        
        
     
    );
  }
}