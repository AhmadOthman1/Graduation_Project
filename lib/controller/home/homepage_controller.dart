import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/Calender/Calender.dart';
import 'package:growify/view/screen/homescreen/chat/chatmainpage.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:growify/view/widget/homePage/commentsMainpage.dart';
import 'package:growify/view/widget/homePage/like.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class CommentModel {
  final int? postId;
  final String username;
  final String comment;
  final AssetImage userImage;
  final DateTime time;
  final RxInt likes;
  final String email;
  final RxBool isLiked;

  CommentModel({
    required this.username,
    this.postId,
    required this.comment,
    required this.userImage,
    required this.time,
    required this.email,
    bool isLiked = false,
    int likes = 0,
  })  : likes = likes.obs,
        isLiked = isLiked.obs;
}

abstract class HomePageController extends GetxController {
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
  addComment(String username, String newComment, String email, int thePostId);
  toggleLikecomment(int index);
  gotoCommentPage(int id);
  //
  goToChat();
  //
  goToCalenderPage();
}

class HomePageControllerImp extends HomePageController {
  final RxList<CommentModel> comments = <CommentModel>[].obs;


  final RxList<CommentModel> comments1 = <CommentModel>[
    CommentModel(
      username: 'User1',
      comment: 'This is a comment.',
      userImage: const AssetImage('images/islam.jpeg'),
      time: DateTime.now(),
      email: 'awsobaida07@gmail.com',
      likes: 12,
      isLiked: true,
    ),
    CommentModel(
      username: 'User2',
      comment: 'Nice post!',
      userImage: const AssetImage('images/Netflix.png'),
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      likes: 5,
      email: 'awsobaida07@gmail.com',
    ),
    CommentModel(
      username: 'User3',
      comment: 'Great content.',
      userImage: const AssetImage('images/harri.png'),
      time: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 10,
      email: 's11923787@stu.najah.edu',
    ),
  ].obs;

  final RxList<Map<String, dynamic>> likesOnComment = <Map<String, dynamic>>[
    {
      'name': 'Islam Aws',
      'username': '@islam_aws',
      'image': 'images/islam.jpeg',
      'email': 'awsobaida07@gmail.com',
    },
    {
      'name': 'Obaida Aws',
      'username': '@obaida_aws',
      'image': 'images/obaida.jpeg',
      'email': 's11923787@stu.najah.edu',
    },
    // Add more colleagues as needed
  ].obs;

  final RxList<Map<String, dynamic>> likes = <Map<String, dynamic>>[
    {
      'name': 'Islam Aws',
      'username': '@islam_aws',
      'image': 'images/islam.jpeg',
      'email': 'awsobaida07@gmail.com',
    },
    {
      'name': 'Obaida Aws',
      'username': '@obaida_aws',
      'image': 'images/obaida.jpeg',
      'email': 's11923787@stu.najah.edu',
    },
    // Add more colleagues as needed
  ].obs;

  final RxList<Map<String, dynamic>> posts = <Map<String, dynamic>>[
    {
      'name': 'Obaida Aws',
      'id': 1,
      'time': '1 hour ago',
      'content': 'Computer engineer in my fifth year at Al Najah University.',
      'image': 'images/obaida.jpeg',
      'like': 165,
      'comment': 87,
      'isLiked': false,
      'email': 's11923787@stu.najah.edu',
    },
    {
      'name': 'Islam Aws',
      'id': 2,
      'time': '2 hours ago',
      'content': 'This is my brother, and he is 8 months old.',
      'image': 'images/islam.jpeg',
      'like': 123,
      'comment': 46,
      'isLiked': false,
      'email': 'awsobaida07@gmail.com',
    },
  ].obs;

    int getLikes(int index) {
    return posts[index]['like'];
  }
  
   int getComments(int index) {
    return posts[index]['comment'];
  }


    void toggleLike(int index) {
    final post = posts[index];
    post['isLiked'] = !post['isLiked'];

    if (post['isLiked']) {
      post['like']++;
      addLike({
        'name': 'Islam Aws',
        'username': '@islam_aws',
        'image': 'images/islam.jpeg',
        'email':'awsobaida07@gmail.com'
      });
    } else {
      removeLike('awsobaida07@gmail.com');
      post['like']--;
    }

    update(); // Notify GetBuilder to rebuild
  }

  bool isLiked(int index) {
    return posts[index]['isLiked'];
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





  //////////////////////////////

 

  @override
  void addComment(String username, String newComment, String email, int thePostId) {
    const userImage = AssetImage('images/obaida.jpeg');
    final time = DateTime.now();
    comments.add(CommentModel(
        username: username,
        comment: newComment,
        userImage: userImage,
        time: time,
        email: email));
  }

  @override
  void toggleLikecomment(int index) {
    final comment = comments[index];
    comment.isLiked.value = !comment.isLiked.value;

    if (comment.isLiked.value) {
      comment.likes.value++;
      addLikeOnComment({
        'name': 'Islam Aws',
        'username': '@islam_aws',
        'image': 'images/islam.jpeg',
        'email': 'awsobaida07@gmail.com',
      });
    } else {
      removeLikeFromComment('awsobaida07@gmail.com');
      comment.likes.value--;
    }

    update(); // Notify GetBuilder to rebuild
  }

  @override
  void gotoCommentPage(int id) {
    Get.to(CommentsMainPage(
      
    ), arguments: {
      'comments': comments1,
    });
  }

  @override
  Future getprofilefromcomment(String email) async {
    var url = "$urlStarter/user/settingsGetMainInfo?email=$email";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  @override
  Future gotoprofileFromcomment(String email) async {
    var res = await getprofilefromcomment(email);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      gotoprofileFromcomment(email);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      Get.to(ColleaguesProfile(userData: [resbody["user"]]));
    }
  }

  @override
  void addLikeOnComment(Map<String, dynamic> likesOnComment) {
    likes.add(likesOnComment);
    update(); // Notify listeners
  }

  @override
  void removeLikeFromComment(String email) {
    likes.removeWhere((likesOnComment) => likesOnComment['email'] == email);
    update(); // Notify listeners
  }

  @override
  void addLike(Map<String, dynamic> newLike) {
    likes.add(newLike);
    update(); // Notify listeners
  }

  @override
  void removeLike(String email) {
    likes.removeWhere((like) => like['email'] == email);
    update(); // Notify listeners
  }

  @override
  void goToLikePage(int postId) {
    Get.to(Like());
  }

  

  @override
  goToSettingsPgae() {
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

  @override
  Future getprfilepage() async {
    var url = "$urlStarter/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  @override
  goToprofilepage() async {
    var res = await getprfilepage();
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToprofilepage();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      Get.to(ProfileMainPage(userData: [resbody["user"]]));
    }
  }

  @override
  Future getprfileColleaguespage(String email) async {
    var url = "$urlStarter/user/settingsGetMainInfo?email=$email";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  @override
  goToProfileColleaguesPage(String email) async {
    var res = await getprfileColleaguespage(email);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToProfileColleaguesPage(email);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      Get.to(ColleaguesProfile(userData: [resbody["user"]]));
    }
  }

  ///////////////////////////////////////////////////////////
  //here we have two list , 
  // the first one to get my colleagues , (row in the page)
  //the second one Colleagues I contacted "send message to him Recently"
  final RxList<Map<String, dynamic>> Mycolleagues = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> colleaguesPreviousmessages = <Map<String, dynamic>>[].obs;
    @override
  void onInit() {
    // Initialize the RxList
    Mycolleagues.assignAll([
      {
      "image": 'images/obaida.jpeg',
      "name": "Obaida",
      "message":"Hi Can i call you",
     
    },
    {
      "image": 'images/harri.png',
      "name": "Ahmad",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/islam.jpeg',
      "name": "Islam",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/Netflix.png',
      "name": "Mousa",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/flutterimage.png',
      "name": "Osman",
      "message":"Hi Can i call you",
     
    },
    {
      "image": 'images/obaida.jpeg',
      "name": "Obada",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/harri.png',
      "name": "Abbas",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/Netflix.png',
      "name": "Mousa",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/islam.jpeg',
      "name": "Islam",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/harri.png',
      "name": "Abbas",
      "message":"Hi Can i call you",
      
    },
    ]);
    
        colleaguesPreviousmessages.assignAll([
      {
      "image": 'images/obaida.jpeg',
      "name": "Obaida",
      "message":"Hi Can i call you",
     
    },
    {
      "image": 'images/harri.png',
      "name": "Ahmad",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/islam.jpeg',
      "name": "Islam",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/Netflix.png',
      "name": "Mousa",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/flutterimage.png',
      "name": "Osman",
      "message":"Hi Can i call you",
     
    },
    {
      "image": 'images/obaida.jpeg',
      "name": "Obada",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/harri.png',
      "name": "Abbas",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/Netflix.png',
      "name": "Mousa",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/islam.jpeg',
      "name": "Islam",
      "message":"Hi Can i call you",
      
    },
    {
      "image": 'images/harri.png',
      "name": "Abbas",
      "message":"Hi Can i call you",
      
    },
    ]);
    super.onInit();
  }
  
  @override
  goToChat() {


    Get.to(ChatMainPage(), arguments: {
      'Mycolleagues': Mycolleagues,
      'colleaguesPreviousmessages':colleaguesPreviousmessages,
    });

   
  }
  
  @override
  goToCalenderPage() {
    Get.to(MainScreen());
  }
}
