import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    controller.comments.assignAll(comments);

    //profileImage = (comment.photo == null) ? "" : controller.comments.photo;

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
            margin: EdgeInsets.symmetric(horizontal: 5),
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
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ListTile(
                          onTap: () {
                            controller
                                .gotoprofileFromcomment(comment.createdBy);
                          },
                          contentPadding: const EdgeInsets.all(8.0),
                          leading: CircleAvatar(
                          //  radius: 60,
                            backgroundImage: controller
                                    .profileImageBytes.isNotEmpty
                                ? MemoryImage(base64Decode(
                                    controller.profileImageBytes.value))
                                : profileBackgroundImage, // Replace with your default photo URL
                          ),
                          title: Text(comment.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comment.commentContent),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: comment.isLiked.value
                                          ? Colors.blue
                                          : null,
                                    ),
                                    onPressed: () {
                                      controller.toggleLikecomment(index);
                                    },
                                  ),
                                  Text('${comment.likes} Likes'),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Posted ${comment.Date}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
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
                            /*final username = 'Current User';
                            final newComment = commentController.text;
                            final Email = 'awsobaida07@gmail.com';

                            const userImage = AssetImage('images/obaida.jpeg');
                            final time = DateTime.now();
                            final newCommentModel = CommentModel(
                              username: username,
                              comment: newComment,
                              userImage: userImage,
                              time: time,
                              email: Email,
                            );

                            controller.addComment(newCommentModel);
                            print(username);

                            for (int i = 0; i < controller.comments.length; i++) {
                              print(i);
                            }

                            commentController.clear();*/
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
