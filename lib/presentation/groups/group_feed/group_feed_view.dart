import 'package:flutter/material.dart';

class GroupFeedView extends StatelessWidget {
  const GroupFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Feed'),
      ),
      body: const Center(
        child: Text('Group Feed'),
      ),
    );
  }
}