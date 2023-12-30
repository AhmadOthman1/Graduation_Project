import 'package:flutter/material.dart';
import 'package:growify/view/widget/homePage/posts.dart';

class ShowPost extends StatefulWidget {
 

  const ShowPost({ Key? key, this.postId}) : super(key: key);
  final postId;

  @override
  _ShowPostState createState() => _ShowPostState();
}

class _ShowPostState extends State<ShowPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Post'),
      ),
      body: NestedScrollView(
        
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child:
      Container(
        height: 50,

      )
      )
      ];},
      body: Post(username: 'AhmadOthman'),
      )
    );
  }
}
