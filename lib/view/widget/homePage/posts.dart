import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/Post_controller.dart';
import 'package:growify/global.dart';

class Post extends StatefulWidget {
  String? username;
  bool? isPage;
  bool?isAdmin;
  String? postId;
  Post({this.username, Key? key, this.isPage, this.isAdmin,this.postId}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  late PostControllerImp controller;

  ImageProvider<Object>? profileBackgroundImage;
  late ImageProvider<Object> postBackgroundImage;
  String? profileImage;
  String? postImage;
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  final AssetImage trImage = const AssetImage("images/transparent.png");

  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = PostControllerImp();
    loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> loadData() async {
    print('Loading data...');
    try {
      await controller.getPostfromDataBase(
          widget.username, controller.page, widget.isPage,widget.postId);
      setState(() {
        controller.page++;
        controller.posts;
      });
      print('Data loaded: ${controller.posts.length} notifications');
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void _scrollListener() {
    print(controller.page);
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !isLoading) {
      // reached the bottom, load more notifications
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () => ListView.separated(
          controller: _scrollController,
          itemCount:
              controller.posts.length + 1, // +1 for the loading indicator
          separatorBuilder: (context, index) => const SizedBox(height: 0,),
          itemBuilder: (context, index) {
            if (index < controller.posts.length) {
              final post = controller.posts[index];
              profileImage =
                  (post["userPhoto"] == null) ? "" : post["userPhoto"];
              profileBackgroundImage =
                  (profileImage != null && profileImage != "")
                      ? Image.network("$urlStarter/${profileImage!}").image
                      : defultprofileImage;
              postImage = (post["photo"] == null) ? "" : post["photo"];
              postBackgroundImage = (postImage != null && postImage != "")
                  ? Image.network("$urlStarter/${postImage!}").image
                  : trImage;

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
                                      if(post['isUser']!= null && post['isUser']){

                                          controller.goToUserPage( post['createdBy']);
                                      }else if(post['isUser']!= null && post['isUser']==false){

                                          controller.goToPage(post['createdBy']);
                                      }
                                      
                                    },
                                    child: CircleAvatar(
                                      backgroundImage: profileBackgroundImage,
                                      radius: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                onSelected: (String option) async {
                                  await controller.onMoreOptionSelected(
                                      option, post['createdBy'] ,post['id'],widget.isPage);
                                },
                                itemBuilder: (BuildContext context) {
                                  if (post['createdBy'] == GetStorage().read('username')) {
                                    controller.moreOptions
                                        .assignAll(["Delete"]);
                                    return controller.moreOptions
                                        .map((String option) {
                                      return PopupMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList();
                                  } else if (widget.isPage != null && widget.isAdmin != null && widget.isPage==true && widget.isAdmin==true) {
                                    controller.moreOptions
                                        .assignAll(["Delete"]);
                                    return controller.moreOptions
                                        .map((String option) {
                                      return PopupMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList();
                                  } else {
                                    controller.moreOptions
                                        .assignAll(["Report"]);
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
                                    controller.goToLikePage(
                                        postId, widget.isPage??(post['isUser']!= null ? !post['isUser'] : null));
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.thumb_up,
                                        color: Colors.blue,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 5),
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
                                    controller.gotoCommentPage(
                                        postId,
                                        widget.isPage??(post['isUser']!= null ? !post['isUser'] : null),
                                        widget.isAdmin,                                        
                                        post['name'],
                                        post["photo"],
                                        post['createdBy']);
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 5),
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
                                      controller.toggleLike(
                                          index, widget.isPage??(post['isUser']!= null ? !post['isUser'] : null));
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 35),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.thumb_up,
                                          color: controller.isLiked(index)
                                              ? Colors.blue
                                              : Colors.grey,
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
                                    controller.gotoCommentPage(
                                        postId,
                                        widget.isPage??(post['isUser']!= null ? !post['isUser'] : null),
                                        widget.isAdmin,
                                        post['name'],
                                        post["photo"],
                                        post['createdBy']);
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
            } else {
              // Loading indicator at the end of the list
              return isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(); // An empty container when loading is complete
            }
          },
        ),
      ),
    );
  }
}
