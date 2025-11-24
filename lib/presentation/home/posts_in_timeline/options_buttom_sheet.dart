import 'package:flutter/material.dart';
import 'package:auth/constants/colors';

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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            // Save + Copy Link
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSquareButton(
                    icon: Icons.bookmark_border,
                    label: 'Save',
                    onTap: () {
                      onSave(); // calls the same toggleSave callback from PostStates
                    },
                  ),
                  _buildSquareButton(
                    icon: Icons.link_outlined,
                    label: 'Copy Link',
                    onTap: onCopyLink,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),

            // View Edit History + Not Interested + Report
            _buildListOption(
              context,
              icon: Icons.history,
              text: 'View Edit History',
              color: Colors.black87,
              onTap: onViewEditHistory,
            ),
            _buildListOption(
              context,
              icon: isNotInterested
                  ? Icons.visibility
                  : Icons.visibility_off_outlined,
              text: isNotInterested ? 'Interested' : 'Not Interested',
              color: Colors.black87,
              onTap: () {
                onNotInterested();
              },
            ),

            _buildListOption(
              context,
              icon: Icons.report_gmailerrorred_outlined,
              text: 'Report',
              color: Colors.redAccent,
              onTap: onReportFlow,
            ),
          ],
        ),
      ),
    );
  }

  // Square button used in the top row (Save, Copy Link)
  Widget _buildSquareButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
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
    );
  }

  // List option used in the bottom part (View Edit History, Not Interested, Report)
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
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop();
        onTap();
      },
    );
  }
}
