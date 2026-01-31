
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyGroupView extends StatelessWidget {
  const MyGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),

        elevation: 0,
      ),
      body: Center(
        child: Text('My Group View'),
      ),
    );
  }
}