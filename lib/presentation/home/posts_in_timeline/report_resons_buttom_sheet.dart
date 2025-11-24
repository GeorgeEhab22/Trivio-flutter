import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class ReportReasonsBottomSheet extends StatelessWidget {
  final Future<bool> Function(String reason) onReportSelected;

  const ReportReasonsBottomSheet({super.key, required this.onReportSelected});

  @override
  Widget build(BuildContext context) {
    final reasons = [
      "Spam or irrelevant content",
      "Toxic or offensive behavior",
      "False or misleading information",
      "Promotion / advertising not allowed",
      "Other",
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
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
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            const Center(child: Text("Report", style: Styles.textStyle20)),
            const SizedBox(height: 12),

            const Text(
              "Why are you reporting this post?",
              style: Styles.textStyle20,
            ),
            const SizedBox(height: 12),

            Text(
              "Your feedback helps us keep the football community safe and enjoyable.",
              style: Styles.textStyle16.copyWith(color: Colors.black54),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reasons.length,
              itemBuilder: (context, i) {
                final reason = reasons[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10), // مسافة بسيطة بدل Divider
                  child: GestureDetector(
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      // final overlayContext = context;

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      // final success = await onReportSelected(reason);

                      if (!navigator.mounted) return;

                      navigator.pop(); // remove loading
                      navigator.pop(); // close sheet

                      // showCustomSnackBar(
                      //   overlayContext,
                      //   success ? 'Post was reported' : 'Failed to report',
                      //   success,
                      // );
                    },
                    child: Text(
                      reason,
                      style: Styles.textStyle16
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
