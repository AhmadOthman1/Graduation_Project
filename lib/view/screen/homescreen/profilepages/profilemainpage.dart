import 'package:flutter/material.dart';
import 'package:growify/view/widget/homePage/posts.dart';

class ProfileMainPage extends StatelessWidget {
  final AssetImage _profileImage = AssetImage("images/obaida.jpeg");
  final AssetImage _coverImage = AssetImage("images/flutterimage.png");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Obaida Profile"),
      ),
      body: Stack(
        children: [
          // Cover Image
          Image(
            image: _coverImage,
            fit: BoxFit.cover,
            height: 200, // Adjust the height as needed
          ),
          // Profile Image and User Details
          Container(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 160), // Space for the cover image
                Align(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: _profileImage,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          children: [
                            Text(
                              "John Doe",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Frontend Developer",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Divider(
                        color: Color.fromARGB(255, 194, 193, 193),
                        thickness: 2.0,
                      ),
                      SizedBox(height: 16),
                      // Add a ListView.builder here
                      Post(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
