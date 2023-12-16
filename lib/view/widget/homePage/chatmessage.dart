import 'package:flutter/material.dart';
import 'package:growify/global.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final String userName;
  final String userPhoto;
  final String createdAt;
  final String? image;

  const ChatMessage({
    super.key,
    required this.text,
    this.isUser = false,
    this.userName = '',
    this.userPhoto = '',
    this.createdAt = '',
    this.image,
  });
  String get formattedCreatedAt {
    // Format the createdAt date according to your needs
    DateTime dateTime = DateTime.parse(createdAt);
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              // Display user name and photo if not the current user
              Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: (userPhoto != '')
                        ? Image.network("$urlStarter/${userPhoto}").image
                        : const AssetImage("images/profileImage.jpg"),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    formattedCreatedAt,
                    style: TextStyle(
                      fontSize: 12,
                      color: isUser ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
            if (isUser) ...[
              Text(
                formattedCreatedAt,
                style: TextStyle(
                  fontSize: 12,
                  color: isUser ? Colors.white : Colors.grey,
                ),
              ),
            ],
            if (image != null) ...[
              Image.network(
                "$urlStarter/${image!}",
                
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
