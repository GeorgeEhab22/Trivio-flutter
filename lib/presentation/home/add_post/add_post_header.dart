import 'package:flutter/material.dart';
import 'package:auth/common/basic_app_button.dart';
import 'package:go_router/go_router.dart';

class AddPostHeader extends StatelessWidget {
  final VoidCallback onPost;
  final bool isPostEnabled;

  const AddPostHeader({
    super.key, 
    required this.onPost,
    this.isPostEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            tooltip: 'Back',
            splashRadius: 20,
            onPressed: () => context.pop(),
          ),
          const Text(
            "Create New Post",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 90,
            height: 36,
            child: Opacity(
              opacity: isPostEnabled ? 1.0 : 0.5,
              child: BasicAppButton(
                onPressed: isPostEnabled ? onPost : () {},
                height: 36,
                width: 80,
                title: "Post",
              ),
            ),
          ),
        ],
      ),
    );
  }
}