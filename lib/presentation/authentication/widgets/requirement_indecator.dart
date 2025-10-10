import 'package:flutter/material.dart';

class Requirement {
  final String label;
  final bool Function(String) check;
  bool isMet = false;
  bool wasMet = false;

  Requirement({required this.label, required this.check});
}
class RequirementIndicator extends StatelessWidget {
  final String label;
  final bool isMet;

  const RequirementIndicator({
    super.key,
    required this.label,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isMet ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isMet ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
