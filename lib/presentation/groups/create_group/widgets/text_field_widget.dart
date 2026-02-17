import 'package:flutter/material.dart';

Widget textFieldWidget({
  required String hint,
  int maxLines = 1,
  TextEditingController? controller,
  String? errorText,
  ValueChanged<String>? onChanged,
}) {
  return Focus(
    child: Builder(
      builder: (context) {
        final bool isFocused = Focus.of(context).hasFocus;
        const Color primaryColor = Color(0xff42C83C);
        const Color errorColor = Colors.redAccent;
        final bool hasError = errorText != null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isFocused
                      ? primaryColor
                      : (hasError
                            ? errorColor
                            : Colors.grey.withValues(alpha: 0.5)),
                  width: (isFocused || hasError) ? 2 : 0.8,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: controller,
                  maxLines: maxLines,
                  onChanged: (value) =>onChanged?.call(value),
                  decoration: InputDecoration(
                    labelText: hint,
                    errorStyle: const TextStyle(height: 0),
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
            ),

            if (hasError&&!isFocused)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8),
                child: Text(
                  errorText,
                  style: const TextStyle(color: errorColor, fontSize: 12),
                ),
              ),
          ],
        );
      },
    ),
  );
}
