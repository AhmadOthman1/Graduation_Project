import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/Post_controller.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/widget/homePage/posts.dart';

class CommentsMainPage extends StatefulWidget {
  const CommentsMainPage({super.key, this.index});
  final index;

  @override
  _CommentsMainPageState createState() => _CommentsMainPageState();
}

class _CommentsMainPageState extends State<CommentsMainPage> {
  PostControllerImp controller = Get.put(PostControllerImp(rebuildCallback: () {  }));
  final SearchControllerImp searchcontroller = Get.put(SearchControllerImp());
  final TextEditingController commentController = TextEditingController();

  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  String? profileImageBytes;
  String? profileImageBytesName;
  String? profileImageExt;
  String? profileImage;
  ImageProvider<Object>? profileBackgroundImage;
  int sendButtonPressCount = 0;

  @override
  Widget build(BuildContext context) {
    var args = Get.arguments;
    RxList<CommentModel> comments = args != null
        ? (args['comments'] as List<CommentModel>).obs
        : <CommentModel>[].obs;
    print("*******=======");
    print(comments);
    int postId = args?['postId'] ?? 0;
    String name = args?['name'] ??
        (GetStorage().read("firstname") + " " + GetStorage().read("lastname"));
    bool? isPage = args?['isPage'] ?? false;

    bool? isAdmin = args?['isAdmin'] ?? false;
    var photo;

    if (isPage == true && isAdmin == true) {
      photo = GetStorage().read("photopage");
    } else {
      photo = GetStorage().read("photo");
    }

    profileBackgroundImage = (photo != null && photo.isNotEmpty)
        ? Image.network("$urlStarter/$photo").image
        : defultprofileImage;
    String createdBy = args?['createdBy'] ;
    controller.comments.assignAll(comments);

    print("////////////////////");
    print(comments.length);
    print("********");

    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Pass counter value back when navigating back
            Get.back(result: {'sendButtonPressCount': sendButtonPressCount});
          },
        ),
      ),
      body: GetX<PostControllerImp>(  
        builder: (controller) {
           if (kIsWeb) {
              return Container(
              
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Container()),
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                      color: Colors.white,
                      
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:
                              Offset(0, 3), // changes the position of shadow
                        ),
                      ],
                    ),
                        child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.75,
                                    child: Column(
                        children: [
                          Flexible(
                            child: ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                profileImage =
                                    (comment.photo == null) ? "" : comment.photo;
                        
                                profileBackgroundImage = (profileImage != null &&
                                        profileImage != "")
                                    ? Image.network("$urlStarter/${profileImage!}").image
                                    : defultprofileImage;
                        
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    /* onTap: () {
                                    //  controller
                                        //  .gotoprofileFromcomment(comment.createdBy);
                                    },*/
                                    contentPadding: const EdgeInsets.all(8.0),
                                    trailing: PopupMenuButton<String>(
                                      icon: const Icon(Icons.more_vert),
                                      onSelected: (String option) async {
                                        var status =
                                            await controller.onCommentOptionSelected(
                                              context,
                                          option,
                                          createdBy,
                                          comment.id,
                                          isPage,
                                        ); // comment.createdBy: the username of the comment creator, we can find  the post creator via comment id
                                        if (status == 200) {
                                          var thisCommentId = comment.id;
                                          comments.removeWhere(
                                              (comment) => comment.id == thisCommentId);
                                          status = null;
                                          controller.update();
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        //if the post created by the user, or the comment created by the user he can delete it
                                        if (createdBy == GetStorage().read("username") ||
                                            comment.createdBy ==
                                                GetStorage().read("username")) {
                                          controller.moreOptions.assignAll(["Delete"]);
                                          return controller.moreOptions
                                              .map((String option) {
                                            return PopupMenuItem<String>(
                                              value: option,
                                              child: Text(option),
                                            );
                                          }).toList();
                                        } else if (isPage != null &&
                                            isAdmin != null &&
                                            isPage == true &&
                                            isAdmin == true) {
                                          controller.moreOptions.assignAll(["Delete"]);
                                          return controller.moreOptions
                                              .map((String option) {
                                            return PopupMenuItem<String>(
                                              value: option,
                                              child: Text(option),
                                            );
                                          }).toList();
                                        } else {
                                          controller.moreOptions.assignAll(["Report"]);
                                          return controller.moreOptions
                                              .map((String option) {
                                            return PopupMenuItem<String>(
                                              value: option,
                                              child: Text(option),
                                            );
                                          }).toList();
                                        }
                                      },
                                    ),
                                    leading: InkWell(
                                      onTap: () async {
                                        if (isPage != null && isPage == true) {
                                          await searchcontroller
                                              .goToPage(comment.createdBy);
                                        }
                        
                                        await controller.goToUserPage(comment.createdBy);
                                      },
                                      child: CircleAvatar(
                                        backgroundImage:
                                            controller.profileImageBytes.isNotEmpty
                                                ? MemoryImage(base64Decode(
                                                    controller.profileImageBytes.value))
                                                : profileBackgroundImage,
                                      ),
                                    ),
                                    title: Text(
                                      "${comment.name}  ● ${comment.Date}",
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 38, 118, 140),
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(comment.commentContent),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: commentController,
                                      onFieldSubmitted: (value) {
                                        commentController.text += '\n';
                                      },
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: const InputDecoration(
                                        hintText: 'Write a comment...',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: () async {
                                      
                                  
                                      final newComment = commentController.text;
                                      var newCommentCreatedBy;
                                      var newCommentName;
                                      var newCommentPhoto;
                                      if (isPage != null &&
                                          isAdmin != null &&
                                          isPage == true &&
                                          isAdmin == true) {
                                        newCommentCreatedBy = createdBy;
                                        newCommentName = name;
                                        newCommentPhoto = photo;
                                      } else {
                                        newCommentCreatedBy =
                                            GetStorage().read("username");
                                        newCommentName = GetStorage().read("firstname") +
                                            " " +
                                            GetStorage().read("lastname");
                                        newCommentPhoto = GetStorage().read("photo");
                                      }
                                      final time = DateTime.now();
                                      final String formattedTime = time.toString();
                                      final newCommentModel = CommentModel(
                                        postId: postId,
                                        createdBy: newCommentCreatedBy,
                                        commentContent: newComment,
                                        Date: formattedTime,
                                        isUser: true,
                                        name: newCommentName,
                                        photo: newCommentPhoto,
                                      );
                                      comments.add(newCommentModel);
                                      controller.update();
                                      await controller.addComment(
                                          newCommentModel, isPage);
                                        
                                        sendButtonPressCount++;
                                     
                                      
                                    
                                      //  Get.find<PostControllerImp>().addComment(newCommentModel);
                                      //controller.update();
                        
                                      commentController.clear();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                                    ),
                                  ),
                      ),
                    ),
                    Expanded(flex: 3, child: Container())
                  ],
                ),
              );
           }
           else{
              return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      profileImage =
                          (comment.photo == null) ? "" : comment.photo;

                      profileBackgroundImage = (profileImage != null &&
                              profileImage != "")
                          ? Image.network("$urlStarter/${profileImage!}").image
                          : defultprofileImage;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          /* onTap: () {
                          //  controller
                              //  .gotoprofileFromcomment(comment.createdBy);
                          },*/
                          contentPadding: const EdgeInsets.all(8.0),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (String option) async {
                              var status =
                                  await controller.onCommentOptionSelected(
                                    context,
                                option,
                                createdBy,
                                comment.id,
                                isPage,
                              ); // comment.createdBy: the username of the comment creator, we can find  the post creator via comment id
                              if (status == 200) {
                                var thisCommentId = comment.id;
                                comments.removeWhere(
                                    (comment) => comment.id == thisCommentId);
                                status = null;
                                controller.update();
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              //if the post created by the user, or the comment created by the user he can delete it
                              if (createdBy == GetStorage().read("username") ||
                                  comment.createdBy ==
                                      GetStorage().read("username")) {
                                controller.moreOptions.assignAll(["Delete"]);
                                return controller.moreOptions
                                    .map((String option) {
                                  return PopupMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList();
                              } else if (isPage != null &&
                                  isAdmin != null &&
                                  isPage == true &&
                                  isAdmin == true) {
                                controller.moreOptions.assignAll(["Delete"]);
                                return controller.moreOptions
                                    .map((String option) {
                                  return PopupMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList();
                              } else {
                                controller.moreOptions.assignAll(["Report"]);
                                return controller.moreOptions
                                    .map((String option) {
                                  return PopupMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList();
                              }
                            },
                          ),
                          leading: InkWell(
                            onTap: () async {
                              if (isPage != null && isPage == true) {
                                await searchcontroller
                                    .goToPage(comment.createdBy);
                              }

                              await controller.goToUserPage(comment.createdBy);
                            },
                            child: CircleAvatar(
                              backgroundImage:
                                  controller.profileImageBytes.isNotEmpty
                                      ? MemoryImage(base64Decode(
                                          controller.profileImageBytes.value))
                                      : profileBackgroundImage,
                            ),
                          ),
                          title: Text(
                            "${comment.name}  ● ${comment.Date}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 38, 118, 140),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comment.commentContent),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: commentController,
                            onFieldSubmitted: (value) {
                              commentController.text += '\n';
                            },
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              hintText: 'Write a comment...',
                              hintStyle: TextStyle(
                                fontSize: 14,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            
                        
                            final newComment = commentController.text;
                            var newCommentCreatedBy;
                            var newCommentName;
                            var newCommentPhoto;
                            if (isPage != null &&
                                isAdmin != null &&
                                isPage == true &&
                                isAdmin == true) {
                              newCommentCreatedBy = createdBy;
                              newCommentName = name;
                              newCommentPhoto = photo;
                            } else {
                              newCommentCreatedBy =
                                  GetStorage().read("username");
                              newCommentName = GetStorage().read("firstname") +
                                  " " +
                                  GetStorage().read("lastname");
                              newCommentPhoto = GetStorage().read("photo");
                            }
                            final time = DateTime.now();
                            final String formattedTime = time.toString();
                            final newCommentModel = CommentModel(
                              postId: postId,
                              createdBy: newCommentCreatedBy,
                              commentContent: newComment,
                              Date: formattedTime,
                              isUser: true,
                              name: newCommentName,
                              photo: newCommentPhoto,
                            );
                            comments.add(newCommentModel);
                            controller.update();
                            await controller.addComment(
                                newCommentModel, isPage);
                              
                              sendButtonPressCount++;
                           
                            
                          
                            //  Get.find<PostControllerImp>().addComment(newCommentModel);
                            //controller.update();

                            commentController.clear();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
           }
        
        },
      ),
    );
  }

  String timeAgoSinceDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
