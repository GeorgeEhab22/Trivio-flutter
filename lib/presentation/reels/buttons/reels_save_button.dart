import 'package:flutter/material.dart';

class ReelsSaveButton extends StatelessWidget {
  const ReelsSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_border,
              color: Colors.white,
              size: 28,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
