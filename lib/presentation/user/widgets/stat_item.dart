import 'package:auth/presentation/user/widgets/custom_column_for_profile_info.dart';
import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onTap;

  const StatItem({required this.label, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: CustomColumnForProfileInfo(
          number: count.toString(),
          thing: label,
        ),
      ),
    );
  }
}