import 'package:flutter/material.dart';
void showCommonGroupBottomSheet({
  required BuildContext context,
  required List<Widget> actions,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet( 
        initialChildSize: 0.4,
        maxChildSize: 0.9,
        minChildSize: 0.2,
        expand: false,
        builder: (context, scrollController) {
          return SafeArea(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                ),
              ),
            ),
          );
        },
      );
    },
  );
}