import 'package:auth/presentation/home/comments/widgets/mini_game.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors';
import 'package:auth/presentation/home/reactions_page.dart';

class CommentsHeader extends StatelessWidget {
  final int reactionsCount;
  
  const CommentsHeader({super.key, required this.reactionsCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReactionsPage()),
            ),
            child: Row(
              children: [
                const Text("Reactions", style: TextStyle(fontSize: 18)),
                const SizedBox(width: 5),
                Text(
                  "$reactionsCount",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.iconsColor),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => const MiniGame(),
              );
            },
          ),
        ],
      ),
    );
  }
}
