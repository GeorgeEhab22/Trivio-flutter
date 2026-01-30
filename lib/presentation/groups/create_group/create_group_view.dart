import 'package:flutter/material.dart';

class CreateGroupView extends StatelessWidget {
  const CreateGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Create Group")),
    body: Container(
      color: Colors.grey,
      child: const Center(child: Text("Create Group")),
    ),
      );
  }
}
