import 'package:auth/common/snack_bar.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, bool success) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50,
      left: 20,
      right: 20,
      child: AnimatedSnackBar(
        message: message,
        success: success,
        onDismissed: () => overlayEntry.remove(), // 🔹 Clean removal
      ),
    ),
  );

  overlay.insert(overlayEntry);
}
