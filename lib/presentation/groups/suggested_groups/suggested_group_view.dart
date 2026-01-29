import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/common/functions/format_number.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/suggested_groups/widgets/suggested_group_app_bar.dart';
import 'package:auth/presentation/home/widgets/exbandable_text.dart';
import 'package:flutter/material.dart';

class SuggestedGroupView extends StatelessWidget {
  const SuggestedGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final int numOfMembers = 5400;
    return Scaffold(
      appBar: const SuggestedGroupAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              'https://picsum.photos/500',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Liverpool", style: Styles.textStyleBold20),
                  const SizedBox(height: 8),
                  Text(
                    "${formatNumber(numOfMembers)} members",
                    style: Styles.textStyle14.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: CustomSquareButton(
                      label: "Join group",
                      onTap: () {},
                      backgroundColor: AppColors.primary,
                      isExpanded: false,
                      textColor: Colors.white,
                      textStyle: Styles.textStyle16,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("About", style: Styles.textStyleBold18),
                  const SizedBox(height: 12),
                  const ExpandableText(
                    text: 'here write group description',
                    previewLines: 4,
                    textStyle: Styles.textStyleNormal15,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.lock_outline, size: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Only members can see who's in the group and what they post.",
                          style: Styles.textStyle14.copyWith(
                            color: Colors.grey,
                          ),
                          maxLines: 2,

                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
