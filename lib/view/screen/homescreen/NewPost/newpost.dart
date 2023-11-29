import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/newpost_controller.dart';

class NewPost extends StatelessWidget {
  final NewPostControllerImp controller = Get.put(NewPostControllerImp());

   NewPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: GetBuilder<NewPostControllerImp>(
          init: controller,
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with image, close icon, and post button
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, right: 15),
                        child: const Icon(
                          Icons.close,
                          size: 30,
                        ),
                      ),
                    ),
                    // go to chat and messages
                    Padding(
                      padding: const EdgeInsets.only(left: 2, right: 15),
                      child: InkWell(
                        onTap: () {
                          // go to the profile Page
                        },
                        child: const CircleAvatar(
                          backgroundImage: AssetImage(
                              'images/obaida.jpeg'), // Replace with your image path
                          radius: 20,
                        ),
                      ),
                    ),
                    // Combo box for privacy
                    DropdownButton<String>(
                      value: controller.selectedPrivacy.value,
                      items: ['Any One', 'Friends'] // Add more options as needed
                          .map((String privacyOption) {
                        return DropdownMenuItem<String>(
                          value: privacyOption,
                          child: Text(privacyOption),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // Set the new value in the DropdownButton
                        controller.updatePrivacy(newValue!);

                        // Print what has been edited
                        print('Privacy edited: $newValue');
                      },
                    ),
                    const Spacer(),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Post",
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Text area for post content
                TextFormField(
                  onChanged: (value) => controller.postContent.value = value,
                  maxLines: 12,
                  decoration: const InputDecoration(
                    hintText: 'What do you want to talk about?',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // Remove the border
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Additional options (e.g., upload image/video)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Upload buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: controller.uploadImage,
                            icon: const Icon(Icons.image),
                            tooltip: 'Upload Image',
                            iconSize: 35,
                            color: Colors.grey,
                          ),
                          IconButton(
                            onPressed: controller.uploadVideo,
                            icon: const Icon(Icons.videocam_sharp),
                            tooltip: 'Upload Video',
                            iconSize: 35,
                            color: Colors.grey,
                          ),

                          IconButton(
                            onPressed: controller.uploadVideo,
                            icon: const Icon(Icons.more_vert),
                            tooltip: 'Upload Video',
                            iconSize: 35,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
