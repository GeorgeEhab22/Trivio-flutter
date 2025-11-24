import 'package:flutter/material.dart';

class PostReactionSummary extends StatelessWidget {
  final int goalCount;
  final int offsideCount;

  const PostReactionSummary({
    super.key,
    required this.goalCount,
    required this.offsideCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = goalCount + offsideCount;

    if (total == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // Goal Icon Summary
          if (goalCount > 0)
            _buildReactionCircle(
              icon: Icons.sports_soccer,
              color: Colors.green,
            ),

          // Overlapping effect
          if (goalCount > 0 && offsideCount > 0)
            Transform.translate(
              offset: const Offset(-6, 0),
              child: _buildReactionCircle(
                icon: Icons.flag,
                color: Colors.redAccent,
              ),
            ),

          // Offside Only
          if (goalCount == 0 && offsideCount > 0)
            _buildReactionCircle(icon: Icons.flag, color: Colors.redAccent),

          const SizedBox(width: 6),

          Text(
            total.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionCircle({required IconData icon, required Color color}) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }
}
