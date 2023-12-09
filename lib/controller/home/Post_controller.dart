import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:growify/view/widget/homePage/commentsMainpage.dart';
import 'package:growify/view/widget/homePage/like.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class CommentModel {
  final int id;
  final int postId;
  final String createdBy;
  final String commentContent;
  final String Date;
  final bool isUser;
  final String name;
  final String? photo;

  final RxInt likes;
  final RxBool isLiked;

  CommentModel({
    required this.id,
    required this.postId,
    required this.createdBy,
    required this.commentContent,
    required this.Date,
    required this.isUser,
    required this.name,
    this.photo,
    bool isLiked = false,
    int likes = 0,
  })  : likes = likes.obs,
        isLiked = isLiked.obs;
}

abstract class PostController extends GetxController {
  getprfileColleaguespage(String email);
  goToProfileColleaguesPage(String email);

  //// for comment
  getprofilefromcomment(String email);
  gotoprofileFromcomment(String email);
  addComment(CommentModel a);
  toggleLikecomment(int index);
  gotoCommentPage(int id);
}

class PostControllerImp extends PostController {
  final RxList<CommentModel> comments = <CommentModel>[].obs;

// the data come from database should you dtore it in the comments1
  final RxList<CommentModel> comments1 = <CommentModel>[].obs;
  //
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
    // Add more colleagues as needed
  ].obs;

  final RxList<Map<String, dynamic>> likes1 = <Map<String, dynamic>>[
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
  // add other list likes1 ...
  final RxList<Map<String, dynamic>> posts = <Map<String, dynamic>>[
    /*{
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
    },*/
  ].obs;

  int page = 1;
  int pageSize = 10;

  PostgetPostfromDataBase(username, page, pageSize) async {
    var url = "$urlStarter/user/getPosts";

    var responce = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'username': username,
        'page': page,
        'pageSize': pageSize,
      }),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      },
    );
    return responce;
  }

  getPostfromDataBase(username, page) async {
    print(username);
    print(page);
    print(pageSize);
    var res = await PostgetPostfromDataBase(username, page, pageSize);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      getPostfromDataBase(username, page);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      posts.assignAll(List<Map<String, dynamic>>.from(data['posts']));
      print(posts);
    }
  }

  int getLikes(int index) {
    return posts[index]['like'];
  }

  int getComments(int index) {
    return posts[index]['comment'];
  }

  void toggleLike(int index) async {
    final post = posts[index];
    post['isLiked'] = !post['isLiked'];
    if (post['isLiked']) {
      post['likeCount']++;
      await addLike(post['id']);
    } else {
      await removeLike(post['id']);
      post['likeCount']--;
    }

    update(); // Notify GetBuilder to rebuild
  }

  PostAddLike(postId) async {
    var url = "$urlStarter/user/addLike";

    var responce = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'postId': postId,
      }),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      },
    );
    return responce;
  }

  @override
  addLike(int postId) async {
    var res = await PostAddLike(postId);
    print(res.statusCode);
    print("===================================");
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      addLike(postId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {}
  }

  postRemoveLike(postId) async {
    var url = "$urlStarter/user/removeLike";

    var responce = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'postId': postId,
      }),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      },
    );
    return responce;
  }

  @override
  removeLike(int postId) async {
    var res = await postRemoveLike(postId);
    print(res.statusCode);
    print("===================================");
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      removeLike(postId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      // Notify listeners
    }
  }

  bool isLiked(int index) {
    return posts[index]['isLiked'];
  }

  RxList<String> moreOptions = <String>[
    'Delete',
    'report',
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

  @override
  void addComment(CommentModel a) {
    comments.add(a);
    update();

    // If you want to update the UI when a new comment is added, uncomment the following line
    // controller.comments.assignAll(comments1);

    // Optionally, you can add the new comment to the existing comments list
    // controller.comments.add(newCommentModel);
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

  getCommentPage(postId) async {
    var url = "$urlStarter/user/getPostComments";

    var responce = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'postId': postId,
      }),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      },
    );
    return responce;
  }

  @override
  gotoCommentPage(int postId) async {
    var res = await getCommentPage(postId);
    print(res.statusCode);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      gotoCommentPage(postId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print("llllllllllllllllllllllllllllll");
        print(data);
      if (data != null) {
        List<CommentModel> newComments = (data ['data']as List).map((commentData) {
          return CommentModel(
            id: commentData['id'],
            postId: commentData['postId'],
            createdBy: commentData['createdBy'],
            commentContent: commentData['commentContent'],
            Date: commentData['Date'],
            isUser: commentData['isUser'],
            name: commentData['name'],
            photo: commentData['photo'],
          );
        }).toList();

        comments1.assignAll(newComments);
        print("llllllllllllllllllllllllllllll");
        print(comments1);
        Get.to(CommentsMainPage(), arguments: {
          'comments': comments1,
        });
      } else {
        print("Invalid or missing 'data' property in response.");
        // Handle the case where 'data' property is missing or invalid
      }
    }
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

  // should add your data from database in likes1
  getPostLikes(postId) async {
    var url = "$urlStarter/user/getPostLikes";

    var responce = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'postId': postId,
      }),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      },
    );
    return responce;
  }

  @override
  goToLikePage(int postId) async {
    var res = await getPostLikes(postId);
    print(res.statusCode);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToLikePage(postId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      likes1.assignAll([Map<String, dynamic>.from(data)]);
      print(likes1);
      Get.to(Like(), arguments: {'likes': likes1});
    }
  }

  @override
  Future getprfilepage() async {
    var url =
        "$urlStarter/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
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
  goToProfileColleaguesPage(String createdBy) async {
    if (createdBy == GetStorage().read('username')) {
      return;
    }
    var res = await getprfileColleaguespage(createdBy);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToProfileColleaguesPage(createdBy);
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
}
