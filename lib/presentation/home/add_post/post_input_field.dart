import 'package:flutter/material.dart';

class PostInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const PostInputField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of( context).cardColor,
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "What's happening on your mind?",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
