import 'package:flutter/material.dart';
import 'package:auth/common/basic_app_button.dart';

class AddPostHeader extends StatelessWidget {
  final VoidCallback onPost;
  const AddPostHeader({super.key, required this.onPost});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            "Create New Post",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 90,
            height: 36,
            child: BasicAppButton(
              onPressed: onPost,
              height: 36,
              width: 80,
              title: "Post",
            ),
          ),
        ],
      ),
    );
  }
}
