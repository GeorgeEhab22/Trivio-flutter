import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddCoverPhotoView extends StatelessWidget {
  const AddCoverPhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).iconTheme.color,
            size: 25,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text("Add a cover photo", style: Styles.textStyleBold20),
                const SizedBox(height: 8),
                Text(
                  "Get noticed with an image that helps show what your group is all about.",
                  style: Styles.textStyle14.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                InkWell(
                  onTap: () {
                    BottomSheetManager.showMediaSourceSheet(
                      context,
                      false, // photo only
                      onPicked: (files) {
                        // TODO  : handle addd media
                        // cubit.addMedia(files);
                      },
                    );
                  },
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text("Upload a photo", style: Styles.textStyle16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomSquareButton(
              label: "Create group",
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
              textStyle: Styles.textStyle16,
              isExpanded: true,
              onTap: () {
                //TODO: link craete the group logic
                context.go(AppRoutes.myGroup);
              },
            ),
          ),
        ],
      ),
    );
  }
}
