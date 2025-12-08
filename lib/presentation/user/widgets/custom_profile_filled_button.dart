import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';

class CustomProfileFilledButton extends StatelessWidget {
  final VoidCallback onpressed;
  final String displayText;
  final IconData icon;
  final Color? color;

  const CustomProfileFilledButton({
    super.key,
    required this.onpressed,
    required this.displayText,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    var iconAndTextColor = color != null ? Colors.white : Colors.black;
    return FilledButton(
      onPressed: onpressed,
      style: ButtonStyle(
        backgroundColor: color != null
            ? WidgetStatePropertyAll(color)
            : WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: color == null
                ? BorderSide(color: AppColors.customGrey, width: 2)
                : BorderSide.none,
          ),
        ),
        fixedSize: WidgetStatePropertyAll(Size(double.infinity, 40)),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconAndTextColor),
            SizedBox(width: 8),
            Text(
              displayText,
              style: Styles.textStyle14.copyWith(color: iconAndTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
