import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/ReportPages/ReportComment.dart';
import 'package:growify/view/screen/homescreen/ReportPages/ReportPost.dart';
import 'package:growify/view/screen/homescreen/myPage/ColleaguesPageProfile.dart';
import 'package:growify/view/screen/homescreen/myPage/Pageprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:growify/view/widget/homePage/commentsMainpage.dart';
import 'package:growify/view/widget/homePage/like.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());
class PageInfo {
  final String id;
  final String name;
  final String? description;
  final String? country;
  final String? address;
  final String? contactInfo;
  final String? specialty;
  final String? pageType;
  final String? photo;
  final String? coverImage;
  final String? postCount;
  final String? followCount;

  PageInfo(this.id, this.name, this.description, this.country, this.address, this.contactInfo, this.specialty, this.pageType, this.photo, this.coverImage, this.postCount , this.followCount);
}
class CommentModel {
  final int? id;
  final int postId;
  final String createdBy;
  final String commentContent;
  final String? Date;
  final bool isUser;
  final String? name;
  final String? photo;

  CommentModel({
    this.id,
    required this.postId,
    required this.createdBy,
    required this.commentContent,
    this.Date,
    required this.isUser,
    this.name,
    this.photo,
  });
}

abstract class PostController extends GetxController {
  bool isLoading = false;

  //// for comment
  getprofilefromcomment(String email);
  gotoprofileFromcomment(String email);
}

class PostControllerImp extends PostController {
// for photo on the comment
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;
///////////////////////////////////////////////////////////////
// for photo on the like
  final RxString profileImageBytes1 = ''.obs;
  final RxString profileImageBytesName1 = ''.obs;
  final RxString profileImageExt1 = ''.obs;
///////////////////////////////////////////////////////////////

  final RxList<CommentModel> comments = <CommentModel>[].obs;

// the data come from database should you dtore it in the comments1
  final RxList<CommentModel> comments1 = <CommentModel>[].obs;
  //

  final RxList<Map<String, dynamic>> likes = <Map<String, dynamic>>[
    // Add more colleagues as needed
  ].obs;

  final RxList<Map<String, dynamic>> likes1 = <Map<String, dynamic>>[
    // Add more colleagues as needed
  ].obs;
  // add other list likes1 ...
  final RxList<Map<String, dynamic>> posts = <Map<String, dynamic>>[].obs;

  int page = 1;
  int pageSize = 10;

  PostgetPostfromDataBase(username, page, pageSize,
      [bool? isPage = false, String? postId]) async {
    print(page);

    if (isPage != null && isPage) {
      print(isPage);
      print("-------------------------------------");
      var url = "$urlStarter/user/getPagePosts";
      var responce = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'pageId': username,
          'pages': page,
          'pageSize': pageSize,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),
        },
      );
      return responce;
    } else {
      if (postId != null) {//get one post only
        var url = "$urlStarter/user/getPost";
        var responce = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            'username': username,
            'postId': postId,
          }),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Authorization': 'bearer ' + GetStorage().read('accessToken'),
          },
        );
        return responce;
      } else {
        var url = "$urlStarter/user/getPosts";
        var responce = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            'username': username,
            'pages': page,
            'pageSize': pageSize,
          }),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Authorization': 'bearer ' + GetStorage().read('accessToken'),
          },
        );
        return responce;
      }
    }
  }

  getPostfromDataBase(username, page,
      [bool? isPage = false, String? postId]) async {
    print(isPage);
    if (isLoading) {
      return;
    }
    isLoading = true;
    print(username);
    print(page);
    print(pageSize);
    var res =
        await PostgetPostfromDataBase(username, page, pageSize, isPage, postId);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));

      getPostfromDataBase(username, page, isPage, postId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print(data['posts']);
      posts.addAll(List<Map<String, dynamic>>.from(data['posts']));

      print("555555555555555555");
      print(data['posts']);
      print("555555555555555555");
      isLoading = false;
    }
    return;
  }

  int getLikes(int index) {
    return posts[index]['like'];
  }

  int getComments(int index) {
    return posts[index]['comment'];
  }

  void toggleLike(int index, [bool? isPage]) async {
    final post = posts[index];
    post['isLiked'] = !post['isLiked'];
    if (post['isLiked']) {
      post['likeCount']++;
      await addLike(post['id'], isPage);
    } else {
      post['likeCount']--;
      await removeLike(post['id'], isPage);
    }

    update(); // Notify GetBuilder to rebuild
  }

  PostAddLike(postId, [bool? isPage]) async {
    if (isPage != null && isPage) {
      var url = "$urlStarter/user/pageAddLike";

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
    } else {
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
  }

  @override
  addLike(int postId, [bool? isPage]) async {
    var res = await PostAddLike(postId, isPage);
    print(res.statusCode);
    print("===================================");
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      addLike(postId, isPage);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {}
  }

  postRemoveLike(postId, [bool? isPage]) async {
    if (isPage != null && isPage) {
      var url = "$urlStarter/user/pageRemoveLike";

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
    } else {
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
  }

  @override
  removeLike(int postId, [bool? isPage]) async {
    var res = await postRemoveLike(postId, isPage);
    print(res.statusCode);
    print("===================================");
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      removeLike(postId, isPage);
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

  final RxList<String> moreOptions = <String>[
    'Delete',
    'Report',
  ].obs;

  Future<void> onMoreOptionSelected(
      String option, createdBy, postId, isPage) async {
    if (isPage != null && isPage == true) {
      switch (option) {
        case 'Delete':
          await deletePagePost(createdBy, postId);
          break;
        case 'Report':
        await  Get.to(ReportPostPage(postId: postId,));
          break;
      }
    } else {
      switch (option) {
        case 'Delete':
          await deletePost(createdBy, postId);
          break;
        case 'Report':
           await  Get.to(ReportPostPage(postId: postId,));
          break;
      }
    }
  }

  deletePagePost(pageId, postId) async {
    var url = "$urlStarter/user/deletePagePost";

    var responce = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'postId': postId,
        'pageId': pageId,
      }),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      },
    );
    print(responce.statusCode);
    print("===================================");
    if (responce.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      deletePost(pageId, postId);
      return;
    } else if (responce.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(responce.body);
    if (responce.statusCode == 409) {
      return resbody['message'];
    } else if (responce.statusCode == 200) {
      posts.removeWhere((post) => post['id'] == postId);
    }
  }

  deletePost(username, postId) async {
    var url = "$urlStarter/user/deletePost";

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
    print(responce.statusCode);
    print("===================================");
    if (responce.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      deletePost(username, postId);
      return;
    } else if (responce.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(responce.body);
    if (responce.statusCode == 409) {
      return resbody['message'];
    } else if (responce.statusCode == 200) {
      posts.removeWhere((post) => post['id'] == postId);
    }
  }

  onCommentOptionSelected(String option, createdBy, commentId, isPage) async {
    if (isPage != null && isPage == true) {
      switch (option) {
        case 'Delete':
          return await deletePageComment(createdBy, commentId);
          break;
        case 'Report':
        return await  Get.to(ReportCommentPage(commentId: commentId,));
          break;
      }
    } else {
      switch (option) {
        case 'Delete':
          return await deleteComment(createdBy, commentId);
          break;
        case 'Report':
         return await  Get.to(ReportCommentPage(commentId: commentId,));
          break;
      }
    }
  }

  deleteComment(username, commentId) async {
    var url = "$urlStarter/user/deleteComment";

    var responce = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'commentId': commentId,
      }),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      },
    );
    print(responce.statusCode);
    print("===================================");
    if (responce.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      deletePost(username, commentId);
      return;
    } else if (responce.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(responce.body);
    if (responce.statusCode == 409) {
      return resbody['message'];
    } else if (responce.statusCode == 200) {
      return 200;
    }
  }

  deletePageComment(pageId, commentId) async {
    var url = "$urlStarter/user/deletePageComment";

    var responce = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'commentId': commentId,
        'pageId': pageId,
      }),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      },
    );
    print(responce.statusCode);
    print("===================================");
    if (responce.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      deletePost(pageId, commentId);
      return;
    } else if (responce.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(responce.body);
    if (responce.statusCode == 409) {
      return resbody['message'];
    } else if (responce.statusCode == 200) {
      return 200;
    }
  }

  PostAddComment(int postId, String commentContent, [bool? isPage]) async {
    if (isPage != null && isPage) {
      var url = "$urlStarter/user/pageAddComment";
      var responce = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'postId': postId,
          'commentContent': commentContent,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),
        },
      );
      return responce;
    } else {
      var url = "$urlStarter/user/addComment";
      var responce = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'postId': postId,
          'commentContent': commentContent,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer ' + GetStorage().read('accessToken'),
        },
      );
      return responce;
    }
  }

  addComment(CommentModel comment, [bool? isPage]) async {
    if (comment.commentContent == "") {
      return;
    }

    var res =
        await PostAddComment(comment.postId, comment.commentContent, isPage);
    print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;");
    print(res.statusCode);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      addComment(comment, isPage);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      //await gotoCommentPage(comment.postId, true, isPage);
    }

    // If you want to update the UI when a new comment is added, uncomment the following line
    //controller.comments.assignAll(comments1);

    // Optionally, you can add the new comment to the existing comments list
    // controller.comments.add(newCommentModel);
  }

  getCommentPage(postId, [bool? isPage]) async {
    if (isPage != null && isPage) {
      var url = "$urlStarter/user/getPagePostComments";

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
    } else {
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
  }

  gotoCommentPage(int postId,
      [bool? isPage,
      bool? isAdmin,
      String? name,
      String? photo,
      String? createdBy]) async {
    var res = await getCommentPage(postId, isPage);
    print(res.statusCode);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      gotoCommentPage(postId, isPage, isAdmin, name, photo, createdBy);
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
        List<CommentModel> newComments =
            (data['data'] as List).map((commentData) {
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
        comments1.clear();
        comments1.assignAll(newComments);

        print("llllllllllllllllllllllllllllll");
        print(data['data']);
        if (isPage != null && isPage) {
          Get.to(const CommentsMainPage(), arguments: {
            'comments': comments1,
            'postId': postId,
            'isPage': isPage,
            'isAdmin': isAdmin,
            'name': name,
            'photo': photo,
            'createdBy': createdBy,
          });
        } else {
          Get.to(const CommentsMainPage(), arguments: {
            'comments': comments1,
            'postId': postId,
            'createdBy': createdBy,
          });
        }
      } else {
        print("Invalid or missing 'data' property in response.");
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

  // should add your data from database in likes1
  getPostLikes(postId, [bool? isPage]) async {
    if (isPage != null && isPage) {
      var url = "$urlStarter/user/getPagePostLikes";

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
    } else {
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
  }

  @override
  goToLikePage(int postId, [bool? isPage]) async {
    var res = await getPostLikes(postId, isPage);
    print(res.statusCode);
    print(res);
    print(res.body);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToLikePage(postId, isPage);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      likes.assignAll([Map<String, dynamic>.from(data)]);
      print("444444444444");
      print(likes);
      Get.to(const Like(), arguments: {'likes': likes});
    }
  }
/*
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
  }*/


  Future getUserProfilePage(String userUsername) async {
    var url =
        "$urlStarter/user/getUserProfileInfo?ProfileUsername=$userUsername";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  goToUserPage(String userUsername) async {
    print(userUsername);
    print("Hiiiiii");
    if (userUsername == GetStorage().read('username')) {
      await goToprofilepage();
      return;
    }
    var res = await getUserProfilePage(userUsername);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToUserPage(userUsername);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      if (resbody['user'] is Map<String, dynamic>) {
        print("ppppp");
        print([resbody["user"]]);
        //  Get.to(ColleaguesProfile(userData: [resbody["user"]]));

        Get.to(() => ColleaguesProfile(userData: [resbody["user"]]));

        return true;
      }
    }
  }
  Future getProfilePage(String pageId) async {
    var url =
        "$urlStarter/user/getPageProfileInfo?pageId=$pageId";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  goToPage(String pageId) async {
    /*if (pageId == GetStorage().read('username')) {
      await goToprofilepage();
      return;
    }*/
    var res = await getProfilePage(pageId);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToPage(pageId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      var page = resbody['Page'];
      if(page['isAdmin']== true){
        Get.to(PageProfile(isAdmin: page['isAdmin'] , userData: PageInfo(page['id'], page['name'], page['description'], page['country'], page['address'], page['contactInfo'], page['specialty'], page['pageType'], page['photo'], page['coverImage'],page['postCount'],page['followCount'])));
      }else{
        Get.to(ColleaguesPageProfile(following: page['following'],userData: PageInfo(page['id'], page['name'], page['description'], page['country'], page['address'], page['contactInfo'], page['specialty'], page['pageType'], page['photo'], page['coverImage'],page['postCount'],page['followCount'])));
      }
      print(page);
      print(page["isAdmin"]);
    }
  }


  /////////////////////////////////////////////////////
  late int userPostCount;
  late int userConnectionsCount;

  getDashboard() async {
    var url = "$urlStarter/user/getUserProfileDashboard";
    var responce = await http.post(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  loadDashboard() async {
    var res = await getDashboard();
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadDashboard();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      userPostCount = resbody['userPostCount'];
      userConnectionsCount = resbody['userConnectionsCount'];
      print(resbody);
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
    await loadDashboard();
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
      GetStorage().write("photo", resbody["user"]["photo"]);
      Get.off(ProfileMainPage(
          userData: [resbody["user"]],
          userPostCount: userPostCount,
          userConnectionsCount: userConnectionsCount));
    }
  }

  
}
