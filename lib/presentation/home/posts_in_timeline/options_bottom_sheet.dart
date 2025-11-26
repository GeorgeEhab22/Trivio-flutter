import 'package:flutter/material.dart';
import 'package:auth/constants/colors';
// TODO: handle this sheet's actions in the Bloc
class OptionsBottomSheet extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCopyLink;
  final VoidCallback onViewEditHistory;
  final VoidCallback onNotInterested;
  final VoidCallback onReportFlow;
  final bool isNotInterested;

  const OptionsBottomSheet({
    super.key,
    required this.onSave,
    required this.onCopyLink,
    required this.onViewEditHistory,
    required this.onNotInterested,
    required this.onReportFlow,
    required this.isNotInterested,
  });

  @override
  Widget build(BuildContext context) {
    final grey100 = Colors.grey[100] ?? const Color(0xFFF5F5F5);
    final grey300 = Colors.grey[300] ?? const Color(0xFFD6D6D6);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: grey300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSquareButton(
                    label: 'Save',
                    icon: Icons.bookmark_border,
                    backgroundColor: grey100,
                    onTap: () {
                      Navigator.pop(context);
                      onSave();
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildSquareButton(
                    label: 'Copy Link',
                    icon: Icons.link_outlined,
                    backgroundColor: grey100,
                    onTap: () {
                      Navigator.pop(context);
                      onCopyLink();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),

            _buildListOption(
              context,
              icon: Icons.history,
              text: 'View Edit History',
              color: Colors.black87,
              onTap: () {
                Navigator.pop(context);
                onViewEditHistory();
              },
            ),

            _buildListOption(
              context,
              icon: isNotInterested ? Icons.visibility : Icons.visibility_off_outlined,
              text: isNotInterested ? 'Interested' : 'Not Interested',
              color: Colors.black87,
              onTap: () {
                Navigator.pop(context);
                onNotInterested();
              },
            ),

            _buildListOption(
              context,
              icon: Icons.report_gmailerrorred_outlined,
              text: 'Report',
              color: Colors.redAccent,
              onTap: () {
                Navigator.pop(context);
                onReportFlow();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? backgroundColor,
  }) {
    return Expanded(
      child: Material(
        color: backgroundColor ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.iconsColor, size: 24),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListOption(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 24),
      title: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
    );
  }
}
