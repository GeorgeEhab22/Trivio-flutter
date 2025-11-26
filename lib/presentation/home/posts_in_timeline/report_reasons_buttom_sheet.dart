import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
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

    final grey300 = Colors.grey[300] ?? const Color(0xFFD6D6D6);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: const [
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
                  color: grey300,
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
                    onTap: () => _handleReportTap(context, reason),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.report, size: 20, color: Colors.redAccent),
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

  Future<void> _handleReportTap(BuildContext context, String reason) async {
    // Show blocking loading dialog
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dCtx) => const Center(child: CircularProgressIndicator()),
    );

    bool success = false;
    try {
      // Await the provided handler (may be a network call)
      success = await onReportSelected(reason);
    } catch (e) {
      success = false;
    } finally {
      // Remove loading dialog if still mounted
      if (Navigator.of(context).mounted) {
        Navigator.of(context).pop(); // pop loading
      }
    }

    // If the sheet is still visible, close it and show feedback
    if (Navigator.of(context).mounted) {
      Navigator.of(context).pop(); // close sheet
      showCustomSnackBar(
        context,
        success ? 'Post reported — thank you for your feedback' : 'Failed to report post. Please try again.',
        success,
      );
    }
  }
}
