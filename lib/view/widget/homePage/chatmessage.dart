import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:growify/global.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class ChatMessage extends StatefulWidget {
  final String text;
  final bool isUser;
  final String userName;
  final String userPhoto;
  final String createdAt;
  final String? image;
  final String? video;
  final VideoPlayerController? existingVideoController;

  const ChatMessage({
    Key? key,
    required this.text,
    this.isUser = false,
    this.userName = '',
    this.userPhoto = '',
    this.createdAt = '',
    this.image,
    this.video,
    this.existingVideoController,
  }) : super(key: key);

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  late String formattedCreatedAt;
  bool _isDisposed = false;
  VideoPlayerController? _Vcontroller;
bool _isVideoInitialized = false;
  @override
  void initState() {
    super.initState();
    formattedCreatedAt = _formatCreatedAt();
    if (widget.video != null) {
      initializeVideoPlayer();
    }
  }

  String _formatCreatedAt() {
    DateTime dateTime = DateTime.parse(widget.createdAt);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  Future<void> initializeVideoPlayer() async {
    try {
      _Vcontroller = VideoPlayerController.networkUrl(
        Uri.parse("$urlStarter/${widget.video}"),
      );

      await _Vcontroller!.initialize();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }

      _Vcontroller!.addListener(() {
        if (!_Vcontroller!.value.isInitialized) {
          // Handle initialization errors here
          print("Video initialization failed");
        }
      });
    } catch (e) {
      // Handle exceptions during video initialization
      print("Exception during video initialization: $e");
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (widget.existingVideoController == null) {
      _Vcontroller?.dispose();
    }
    super.dispose();
  }

  Widget _buildVideoPlayer() {
    return Builder(
      builder: (context) {
        if (_Vcontroller != null && _Vcontroller!.value.isInitialized) {
          return Column(
            children: [
              AspectRatio(
                aspectRatio: _Vcontroller!.value.aspectRatio,
                child: VideoPlayer(_Vcontroller!),
              ),
              VideoProgressIndicator(_Vcontroller!, allowScrubbing: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _Vcontroller!.value.isPlaying
                          ? _Vcontroller!.pause()
                          : _Vcontroller!.play();
                    },
                    icon: _Vcontroller!.value.isPlaying
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.video != null && !_isVideoInitialized) {
      initializeVideoPlayer(); // Don't build the message widget until the video player is initialized
    
    }
    return Container(
      alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: widget.isUser ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.isUser) ...[
              // Display user name and photo if not the current user
              Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: (widget.userPhoto != '')
                        ? Image.network("$urlStarter/${widget.userPhoto}").image
                        : const AssetImage("images/profileImage.jpg"),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    formattedCreatedAt,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.isUser ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Text(
              widget.text,
              style: const TextStyle(fontSize: 16),
            ),
            if (widget.image != null) ...[
              Image.network(
                "$urlStarter/${widget.image!}",
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Image.memory(
                    base64Decode(widget.image!),
                    fit: BoxFit.cover,
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
            if (widget.video != null) ...[
              _buildVideoPlayer(),
            ],
            if (widget.isUser) ...[
              Text(
                formattedCreatedAt,
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isUser ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
