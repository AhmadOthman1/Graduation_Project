import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Post_controller.dart';
import 'package:growify/global.dart';

class Post extends StatefulWidget {
  String? username;
  Post({this.username, Key? key}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final PostControllerImp controller = PostControllerImp();
  bool isLoading = false;
  ImageProvider<Object>? profileBackgroundImage;
  late ImageProvider<Object> postBackgroundImage;
  String? profileImage;
  String? postImage;
  final AssetImage defultprofileImage = const AssetImage("images/profileImage.jpg");
  final AssetImage trImage = const AssetImage("images/transparent.png");

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // Assuming getPostfromDataBase returns a Future<List<Map<String, dynamic>>?>
    controller.getPostfromDataBase(widget.username, controller.page)?.then((result) {
      if (result != null && result.isNotEmpty) {
       // setState(() {
          isLoading = false;
       // });
        print(isLoading);
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!isLoading) {
        setState(() {
          isLoading = true;
          controller.page++;
        });

        controller.getPostfromDataBase(widget.username, controller.page)?.then((result) {
          if (result != null && result.isNotEmpty) {
            setState(() {
              isLoading = false;
            });
            print(isLoading);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () => ListView.builder(
          controller: _scrollController,
          itemCount: controller.posts.length,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            profileImage = (post["userPhoto"] == null) ? "" : post["userPhoto"];
            profileBackgroundImage = (profileImage != null && profileImage != "") ? Image.network("$urlStarter/" + profileImage!).image : defultprofileImage;
            postImage = (post["photo"] == null) ? "" : post["photo"];
            postBackgroundImage = (postImage != null && postImage != "") ? Image.network("$urlStarter/" + postImage!).image : trImage;
            return Container(
              key: ValueKey(index),
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.goToProfileColleaguesPage(post['createdBy']);
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: profileBackgroundImage,
                                    radius: 30,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          post['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      post['postDate'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (String option) {
                                controller.onMoreOptionSelected(option);
                              },
                              itemBuilder: (BuildContext context) {
                                return controller.moreOptions.map((String option) {
                                  return PopupMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            post['postContent'],
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: postImage != "" ? 400 : 0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: postBackgroundImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  int postId = post['id'];
                                  controller.goToLikePage(postId);
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.thumb_up,
                                      color: Colors.blue,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10, right: 5),
                                      child: Text(
                                        '${post["likeCount"]}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Likes',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              InkWell(
                                onTap: () {
                                  int postId = post['id'];
                                  controller.gotoCommentPage(postId);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 10, right: 5),
                                      child: Text(
                                        '${post["commentCount"]}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Comments',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 194, 193, 193),
                          thickness: 1.0,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    controller.toggleLike(index);
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 35),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.thumb_up,
                                        color: controller.isLiked(index) ? Colors.blue : Colors.grey,
                                      ),
                                      const Text("Like")
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 135),
                              InkWell(
                                onTap: () {
                                  int postId = post['id'];
                                  controller.gotoCommentPage(postId);
                                },
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.comment,
                                      color: Colors.grey,
                                    ),
                                    Text("Comment")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
