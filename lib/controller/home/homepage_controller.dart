import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/myPages_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/notificationspages/notificationmainpage.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:http/http.dart' as http;

class CommentModel {
  final String username;
  final String comment;
  final AssetImage userImage;
  final DateTime time;
  final RxInt likes;
  final String email;

  CommentModel( {
    required this.username,
    required this.comment,
    required this.userImage,
    required this.time,
    required this.email,
    int likes = 0,
  }) : likes = likes.obs;
}


abstract class HomePageController extends GetxController{

goToSignup();
goToForgetPassword();
goToProfileColleaguesPage(String email);

goToSettingsPgae();
goToprofilepage();
getprfilepage();
getprfileColleaguespage(String email);
//// for comment
getprofilefromcomment(String email);
gotoprofileFromcomment(String email);
}

class HomePageControllerImp extends HomePageController {

/// for comment 
  final RxList<CommentModel> comments = <CommentModel>[
    CommentModel(
      username: 'User1',
      comment: 'This is a comment.',
      userImage: AssetImage('images/islam.jpeg'),
      time: DateTime.now(),
      email: 'awsobaida07@gmail.com'
      
    ),
    CommentModel(
      username: 'User2',
      comment: 'Nice post!',
      userImage: AssetImage('images/Netflix.png'),
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      likes: 5,
      email: 'awsobaida07@gmail.com'
    ),
    CommentModel(
      username: 'User3',
      comment: 'Great content.',
      userImage: AssetImage('images/harri.png'),
      time: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 10,
      email: 's11923787@stu.najah.edu'
    ),
  ].obs;

    void addComment(String username, String newComment,String email) {
    final userImage = AssetImage('images/obaida.jpeg');
    final time = DateTime.now();
    comments.add(CommentModel(username: username, comment: newComment, userImage: userImage, time: time,email:email));
  }

  void toggleLikecomment(int index) {
    final comment = comments[index];
    comment.likes(comment.likes.value > 0 ? 0 : 1);
  }


    @override
  Future getprofilefromcomment(String email) async{
          var url = urlStarter + "/user/settingsGetMainInfo?email=${email}";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
  print(responce);
    return responce;

  }

  @override
  Future gotoprofileFromcomment(String email)async {
             var res = await getprofilefromcomment(email);
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    print(resbody);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){


    Get.to(ColleaguesProfile(userData: [resbody["user"]]));
  }
    
  }

  



















  /////////////////////////////////////////////////

//// for the page of likes
  RxList<Map<String, dynamic>> likes = <Map<String, dynamic>>[
    {
      'name': 'Islam Aws',
      'username': '@islam_aws',
      'image': 'images/islam.jpeg',
      'email':'awsobaida07@gmail.com'

    },
    {
      'name': 'Obaida Aws',
      'username': '@obaida_aws',
      'image': 'images/obaida.jpeg',
      'email':'s11923787@stu.najah.edu'
  
    },
    // Add more colleagues as needed
  ].obs;

   void addLike(Map<String, dynamic> newLike) {
    likes.add(newLike);
    update(); // Notify listeners
  }

  void removeLike(String email) {
  likes.removeWhere((like) => like['username'] == email);
  update(); // Notify listeners
}


/////////////////////////////////////////////////////////







// for the posts

  RxList<Map<String, dynamic>> posts = <Map<String, dynamic>>[
    {
      'name': 'Obaida Aws',
      'time': '1 hour ago',
      'content': 'Computer engineer in my fifth year at Al Najah University.',
      'image': 'images/obaida.jpeg',
      'like': 165,
      'isLiked': false,
      'email': 's11923787@stu.najah.edu'
      
    },
    {
      'name': 'Islam Aws',
      'time': '2 hours ago',
      'content': 'This is my brother, and he is 8 months old.',
      'image': 'images/islam.jpeg',
      'like': 123,
      'isLiked': false,
      'email':'awsobaida07@gmail.com'
    },
  ].obs;

  void toggleLike(int index) {
    final post = posts[index];
    post['isLiked'] = !post['isLiked'];

    if (post['isLiked']) {
      post['like']++;
    } else {
      post['like']--;
    }

    update(); // Notify GetBuilder to rebuild
  }

  bool isLiked(int index) {
    return posts[index]['isLiked'];
  }

  int getLikes(int index) {
    return posts[index]['like'];
  }

    RxList<String> moreOptions = <String>[
    'Save Post',
    'Hide Post',
  ].obs;

    void onMoreOptionSelected(String option) {
    // Handle the selected option here
    switch (option) {
      case 'Save Post':
        // Implement save post functionality
        break;
      case 'Hide Post':
        // Implement hide post functionality
        break;
      // Add more options as needed
    }
  }


  

  









////////////////////////////////////////////////////////////////////////
  goToSettingsPgae(){
  Get.toNamed(AppRoute.settings);
}

  @override
  goToSignup() {
    Get.offNamed(AppRoute.signup);
  }

  
 

  @override
  goToForgetPassword() {
    Get.offNamed(AppRoute.forgetpassword);
  }
  

  

  ///////////////////////////////////////////////////////
   
  Future getprfilepage() async{
    
        var url = urlStarter + "/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
  print(responce);
    return responce;

  }
  
  
  @override
  goToprofilepage() async{

     var res = await getprfilepage();
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    print(resbody);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){
     // Get.to(ProfileMainPage(), arguments: {'user': resbody["user"]});


      Get.to(ProfileMainPage(userData: [resbody["user"]]));
    } 
 


   // Get.to(ProfileMainPage());

  }
  @override

   Future getprfileColleaguespage(String email) async{
        var url = urlStarter + "/user/settingsGetMainInfo?email=${email}";
    var responce = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
  print(responce);
    return responce;

  }

  

  

    @override
  goToProfileColleaguesPage(String email)async {
         var res = await getprfileColleaguespage(email);
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    print(resbody);
    if(res.statusCode == 409){
      return resbody['message'];
    }else if(res.statusCode == 200){


    Get.to(ColleaguesProfile(userData: [resbody["user"]]));
  }
  
 
}



  }
