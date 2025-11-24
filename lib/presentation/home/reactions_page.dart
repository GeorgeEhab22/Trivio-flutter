import 'package:flutter/material.dart';
import 'package:auth/constants/colors';

class ReactionsPage extends StatelessWidget {
  const ReactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reactions = [
      {"user": "Sarah Ahmed", "reaction": "❤️"},
      {"user": "Omar Khaled", "reaction": "😂"},
      {"user": "Laila Mohamed", "reaction": "👍"},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Reactions",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: reactions.length,
        itemBuilder: (context, index) {
          final item = reactions[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(item["user"]),
            trailing: Text(
              item["reaction"],
              style: const TextStyle(fontSize: 22),
            ),
          );
        },
      ),
    );
  }
}
