import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/view/widget/homePage/comments.dart';

class CommentsMainPage extends StatelessWidget {
  const CommentsMainPage({super.key,required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Comments(postId:id),
         
        

        
        
     
    );
  }
}