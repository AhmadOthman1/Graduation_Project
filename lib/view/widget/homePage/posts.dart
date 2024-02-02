import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/Post_controller.dart';
import 'package:growify/global.dart';
import 'package:video_player/video_player.dart';

class Post extends StatefulWidget {
  String? username;
  bool? isPage;
  bool? isAdmin;
  String? postId;

  Post({this.username, Key? key, this.isPage, this.isAdmin, this.postId})
      : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  late PostControllerImp controller;

  ImageProvider<Object>? profileBackgroundImage;
  late ImageProvider<Object> postBackgroundImage;
  String? profileImage;
  String? postImage;
  final AssetImage defaultProfileImage =
      const AssetImage("images/profileImage.jpg");
  final AssetImage transparentImage = const AssetImage("images/transparent.png");

  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  Map<String, VideoPlayerController?> _videoControllers = {};


  int currentPhotoIndex = 0;
  Map<int, int> currentVideoIndex = {};

  // for toggle between them 
  
  

  @override
  void initState() {
    super.initState();

    controller = PostControllerImp(rebuildCallback: () {
      // Empty function since we just need to trigger a rebuild
      setState(() {});
    });
    loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> loadData() async {
    print('Loading data...');
    try {
      await controller.getPostfromDataBase(
          widget.username, controller.page, widget.isPage, widget.postId);

      // Updated: Clear VideoPlayerControllers
      _videoControllers.clear();

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

  // Updated: for video
  Future<void> initializeVideoPlayer(String postId, int index) async {
    final post = controller.posts[index];

    // Check if the post has videos
    if (post["video"] != null && post["video"].isNotEmpty) {
      // Check if the controller is already initialized for this post
      if (_videoControllers[postId] == null) {
        try {
          _videoControllers[postId] = VideoPlayerController.network(
            "$urlStarter/${post["video"][0]["video"]}", // Assuming you want the first video
          );

          await _videoControllers[postId]!.initialize();

          _videoControllers[postId]!.addListener(() {
            if (!_videoControllers[postId]!.value.isInitialized) {
              print("Video initialization failed");
            }
          });
          setState(() {});
        } catch (e) {
          print("Exception during video initialization: $e");
        }
      }
    }
  }

    Future<void> updateVideoPlayer(String postId, int postIndex, int videoIndex) async {
    final post = controller.posts[postIndex];

    if (post["video"] != null && post["video"].length > videoIndex) {
      final videoUrl = "$urlStarter/${post["video"][videoIndex]["video"]}";

      _videoControllers[postId]?.dispose(); // Dispose the old controller
      _videoControllers[postId] = VideoPlayerController.network(videoUrl);

      await _videoControllers[postId]!.initialize();
      setState(() {
        currentVideoIndex[postIndex] = videoIndex; // Update the current video index
      });
    }
  }

  Widget _buildVideoPlayer(String postId, int postIndex) {
    final videoController = _videoControllers[postId];

    return Builder(
      builder: (context) {
        if (videoController != null && videoController.value.isInitialized) {
          final post = controller.posts[postIndex];
          int totalVideos = post["video"].length;
          int currentIndex = currentVideoIndex[postIndex] ?? 0;

          return Column(
            children: [
              AspectRatio(
                aspectRatio: videoController.value.aspectRatio,
                child: VideoPlayer(videoController),
              ),
              VideoProgressIndicator(videoController, allowScrubbing: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: currentIndex > 0
                        ? () => updateVideoPlayer(postId, postIndex, currentIndex - 1)
                        : null,
                  ),
                  IconButton(
                    icon: videoController.value.isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                    onPressed: () {
                      videoController.value.isPlaying ? videoController.pause() : videoController.play();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: currentIndex < totalVideos - 1
                        ? () => updateVideoPlayer(postId, postIndex, currentIndex + 1)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          );
        } else {
          return Container(); // Show empty container or loader
        }
      },
    );
  }
  Container _buildPhotoContainer(String postId, int index) {
  final post = controller.posts[index];

  int totalPhotos = post["photo"].length;
  currentPhotoIndex = currentPhotoIndex % totalPhotos; // Ensure it stays within bounds

  return Container(
    height: postImage != "" ? 400 : 0,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(
          "$urlStarter/${post["photo"][currentPhotoIndex]["photo"]}"),
        fit: BoxFit.cover,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_left,size: 50,),
          onPressed: () {
            setState(() {
              currentPhotoIndex = (currentPhotoIndex - 1 + totalPhotos) % totalPhotos;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.arrow_right,size: 50,),
          onPressed: () {
            setState(() {
              currentPhotoIndex = (currentPhotoIndex + 1) % totalPhotos;
            });
          },
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () => ListView.separated(
          controller: _scrollController,
          itemCount:
              controller.posts.length + 1, // +1 for the loading indicator
          separatorBuilder: (context, index) => const SizedBox(
            height: 0,
          ),
          itemBuilder: (context, index) {
            if (index < controller.posts.length) {
              final post = controller.posts[index];
             if (post["video"] != null) {
                initializeVideoPlayer(post['id'].toString(), index);
              }

              profileImage =
                  (post["userPhoto"] == null) ? "" : post["userPhoto"];
              profileBackgroundImage =
                  (profileImage != null && profileImage != "")
                      ? Image.network("$urlStarter/${profileImage!}").image
                      : defaultProfileImage;
              postImage = (post["photo"] != null && post["photo"].isNotEmpty)
                  ? post["photo"][0]["photo"]
                  : "";
              postBackgroundImage = (postImage != null && postImage != "")
                  ? Image.network("$urlStarter/${postImage!}").image
                  : transparentImage;

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
                                      if (post['isUser'] != null &&
                                          post['isUser']) {
                                        controller
                                            .goToUserPage(post['createdBy']);
                                      } else if (post['isUser'] != null &&
                                          post['isUser'] == false) {
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
                                      option,
                                      post['createdBy'],
                                      post['id'],
                                      widget.isPage,
                                      post['postContent'],
                                      post['selectedPrivacy'],
                                      post["userPhoto"],
                                      context
                                      );
                                },
                                itemBuilder: (BuildContext context) {
                                  if (post['createdBy'] ==
                                      GetStorage().read('username')) {
                                    controller.moreOptions.assignAll([
                                      "Delete",
                                      "Edit post",
                                      "Show edit history"
                                    ]);
                                    return controller.moreOptions
                                        .map((String option) {
                                      return PopupMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList();
                                  } else if (widget.isPage != null &&
                                      widget.isAdmin != null &&
                                      widget.isPage == true &&
                                      widget.isAdmin == true) {
                                    controller.moreOptions.assignAll([
                                      "Delete",
                                      "Edit post",
                                      "Show edit history"
                                    ]);
                                    return controller.moreOptions
                                        .map((String option) {
                                      return PopupMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList();
                                  } else {
                                    controller.moreOptions.assignAll(
                                        ["Report", "Show edit history"]);
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
                          if (post["video"] != null) _buildVideoPlayer(post['id'].toString(),index),
                          const SizedBox(height: 10),
                          Container(
                            height: postImage != "" ? 400 : 0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: postBackgroundImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: post["photo"].isNotEmpty
                                ? _buildPhotoContainer(post['id'].toString(),index)
                                : Container(),
                          ),
                          Container(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    int postId = post['id'];
                                    controller.goToLikePage(
                                      context,
                                        postId,
                                        widget.isPage ??
                                            (post['isUser'] != null
                                                ? !post['isUser']
                                                : null));
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
                                    setState(() {
                                      print("ssssssssssssssssssss");
                                      int postIndex = index;
                                      int postId = post['id'];
                                      controller.gotoCommentPage(
                                        context,
                                        postIndex,
                                        postId,
                                        post['createdBy'],
                                        widget.isPage ??
                                            (post['isUser'] != null
                                                ? !post['isUser']
                                                : null),
                                        widget.isAdmin,
                                        post['name'],
                                        );
                                    });
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
                                          index,
                                          widget.isPage ??
                                              (post['isUser'] != null
                                                  ? !post['isUser']
                                                  : null));
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
                                    setState(() {
                                      int postIndex = index;
                                      int postId = post['id'];
                                      controller.gotoCommentPage(
                                        context,
                                        postIndex,
                                        postId,
                                        post['createdBy'],
                                        widget.isPage ??
                                            (post['isUser'] != null
                                                ? !post['isUser']
                                                : null),
                                        widget.isAdmin,
                                        post['name'],
                                        
                                        
                                      );
                                    });
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
              return isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoControllers.values.forEach((controller) => controller?.dispose());
    super.dispose();
  }
}
