import 'package:flutter/material.dart';
 
 Widget textFieldWidget({required String hint, int maxLines = 1}) {
    return Focus(
      child: Builder(
        builder: (context) {
          final bool isFocused = Focus.of(context).hasFocus;
          const Color primaryColor = Color(0xff42C83C);

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFocused
                    ? primaryColor
                    : Colors.grey.withValues(alpha: 0.5),
                width: isFocused ? 2 : 0.8,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                maxLines: maxLines,
                decoration: InputDecoration(
                  labelText: hint,
                  labelStyle: const TextStyle(color: Colors.grey),
                  floatingLabelStyle: const TextStyle(color: primaryColor),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }