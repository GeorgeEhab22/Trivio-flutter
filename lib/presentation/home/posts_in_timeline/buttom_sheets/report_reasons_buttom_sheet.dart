import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class ReportReasonsBottomSheet extends StatelessWidget {
  final void Function(String reason) onReportSelected;

  const ReportReasonsBottomSheet({super.key, required this.onReportSelected});

  @override
  Widget build(BuildContext context) {
    final handleBarColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]
        : Colors.grey[300];
    final reasons = [
      "Spam or irrelevant content",
      "Toxic or offensive behavior",
      "False or misleading information",
      "Promotion / advertising not allowed",
      "Other",
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: handleBarColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            const Center(child: Text("Report", style: Styles.textStyle20)),
            const SizedBox(height: 12),

            const Text(
              "Why are you reporting this post?",
              style: Styles.textStyle20,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Text(
              "Your feedback helps us keep the football community safe and enjoyable.",
              style: Styles.textStyle16.copyWith(color: Colors.black54),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Reasons list
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reasons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, i) {
                final reason = reasons[i];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => onReportSelected(reason),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                      child: Row(
                        children: [
                          // const Icon(Icons.report, size: 20, color: Colors.redAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              reason,
                              style: Styles.textStyle16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
