import 'package:auth/common/snack_bar.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, bool success) {
  final overlay = Overlay.of(context);
  final directionality = Directionality.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50,
      left: 20,
      right: 20,
      child: Directionality( 
        textDirection: directionality,
        child: Material( 
          color: Colors.transparent,
          child: AnimatedSnackBar(
            message: message,
            success: success,
            onDismissed: () => overlayEntry.remove(),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
}