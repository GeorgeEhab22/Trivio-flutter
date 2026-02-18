import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditPage extends StatelessWidget {
  final String? initialText;
  final String? title;
  final String? hintText;
  final Function(String newText)? onSave;

  const EditPage({
    super.key,
    this.initialText,
    this.title = 'Edit',
    this.hintText = 'Write something...',
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: initialText,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (controller.text.isNotEmpty &&
                  controller.text != initialText) {
                onSave!(controller.text);
                context.pop();
              } else {
                context.pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          maxLines: null,
          autofocus: true,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
