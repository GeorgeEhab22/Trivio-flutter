import 'package:flutter/material.dart';

class GroupImage extends StatelessWidget {
  const GroupImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://picsum.photos/500',
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
