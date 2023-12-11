import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/Post_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/widget/homePage/comments.dart';

class CommentsMainPage extends StatelessWidget {
  final PostControllerImp controller = Get.put(PostControllerImp());
  final TextEditingController commentController = TextEditingController();

  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  String? profileImageBytes;
  String? profileImageBytesName;
  String? profileImageExt;
  String? profileImage;
  ImageProvider<Object>? profileBackgroundImage;

  @override
  Widget build(BuildContext context) {
    var args = Get.arguments;
    RxList<CommentModel> comments = args != null ? args['comments'] : [];
    int postId = args['postId'];

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
      ),
      body: GetBuilder<PostControllerImp>(
        builder: (controller) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            //margin: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: controller.comments.length,
                    itemBuilder: (context, index) {
                      final comment = controller.comments[index];
                      profileImage =
                          (comment.photo == null) ? "" : comment.photo;
                      //
                      profileBackgroundImage = (profileImage != null &&
                              profileImage != "")
                          ? Image.network("$urlStarter/" + profileImage!).image
                          : defultprofileImage;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          onTap: () {
                            controller
                                .gotoprofileFromcomment(comment.createdBy);
                          },
                          contentPadding: const EdgeInsets.all(8.0),
                          leading: CircleAvatar(
                            backgroundImage:
                                controller.profileImageBytes.isNotEmpty
                                    ? MemoryImage(base64Decode(
                                        controller.profileImageBytes.value))
                                    : profileBackgroundImage,
                          ),
                          title: Text(
                            "${comment.name}  ● ${comment.Date}"  ,
                            style: TextStyle(
                              color:  Color.fromARGB(255, 38, 118, 140),
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
                          child: TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: 'Write a comment...',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            final newComment = commentController.text;

                            final time = DateTime.now();
                            final String formattedTime = time.toString();
                            final newCommentModel = CommentModel(
                              postId: postId,
                              createdBy: GetStorage().read("username"),
                              commentContent: newComment,
                              Date: formattedTime,
                              isUser: true,
                            );

                            controller.addComment(newCommentModel);
                            //comments.add(newCommentModel);
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
