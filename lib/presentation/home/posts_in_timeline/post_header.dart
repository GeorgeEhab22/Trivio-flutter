import 'package:auth/constants/colors';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/home/posts_in_timeline/options_bottom_sheet.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
 
  final bool isFollowing;
  
  const PostHeader({
    super.key,
     required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🔹 Follow Button (Logic to be handled via Cubit)
        SizedBox(
          height: 30,
          child: TextButton(
            onPressed: () {
              // TODO: handle follow/unfollow via Cubit
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF5F5F5),
              padding: EdgeInsets.symmetric(horizontal: isFollowing ? 18 : 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isFollowing ? 'Following' : 'Follow',
              style: Styles.textStyle14.copyWith(
                color: AppColors.iconsColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        // 🔹 Options Button (Actions handled via Cubit)
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.iconsColor),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (_) => OptionsBottomSheet(
               
                // onReportFlow: () async {
                //   // Report action can trigger another bottom sheet
                //   await showModalBottomSheet(
                //     context: context,
                //     isScrollControlled: true,
                //     backgroundColor: Colors.transparent,
                //     builder: (_) => ReportReasonsBottomSheet(
                //       onReportSelected: (reason) async {
                //         // TODO: send report action via Cubit
                //         await Future.delayed(
                //           const Duration(milliseconds: 600),
                //         );
                //         debugPrint("✅ Reported reason: $reason");
                //         return true;
                //       },
                //     ),
                //   );
                // },
              ),
            );
          },
        ),
      ],
    );
  }
}
