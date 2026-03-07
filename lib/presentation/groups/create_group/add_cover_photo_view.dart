import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/group_cubit/create_group/create_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/create_group/create_group_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class AddCoverPhotoView extends StatelessWidget {
  const AddCoverPhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    const String defaultAssetPath = 'assets/images/Football Community.png';

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            isArabic
                ? Icons.arrow_back_ios_rounded
                : Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).iconTheme.color,
            size: 25,
          ),
        ),
      ),
      body: BlocConsumer<CreateGroupCubit, CreateGroupState>(
        listener: (context, state) {
          if (state is CreateGroupSuccess) {
            showCustomSnackBar(context, l10n.groupCreatedSuccess, true);
            context.go(AppRoutes.myGroup(state.group.groupId));
          }
          if (state is CreateGroupFailure) {
            showCustomSnackBar(context, state.message, false);
          }
        },
        builder: (context, state) {
          final cubit = context.read<CreateGroupCubit>();

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(l10n.addCoverPhoto, style: Styles.textStyleBold20),
                    const SizedBox(height: 8),
                    Text(
                      l10n.addCoverPhotoSub,
                      style: Styles.textStyle14.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),

                    Stack(
                      children: [
                        Container(
                          height: 220,
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: cubit.groupCoverImage != null
                              ? (kIsWeb
                                    ? Image.network(
                                        cubit.groupCoverImage!.path,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(cubit.groupCoverImage!.path),
                                        fit: BoxFit.cover,
                                      ))
                              : Image.asset(
                                  defaultAssetPath,
                                  fit: BoxFit.cover,
                                ),
                        ),

                        PositionedDirectional(
                          bottom: 12,
                          end: 12,
                          child: CustomSquareButton(
                            label: l10n.edit,
                            backgroundColor: Theme.of(
                              context,
                            ).cardColor.withValues(alpha: 0.8),
                            textColor: Colors.white,
                            textStyle: Styles.textStyle14,
                            height: 10,
                            onTap: () {
                              final currentCubit = context
                                  .read<CreateGroupCubit>();
                              BottomSheetManager.showMediaSourceSheet(
                                context,
                                false,
                                onPicked: (files) {
                                  if (files.isNotEmpty) {
                                    currentCubit.updateImage(files.first);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomSquareButton(
                  label: state is CreateGroupLoading
                      ? l10n.creating
                      : l10n.createGroup,
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                  textStyle: Styles.textStyle16,
                  isExpanded: true,
                  onTap: state is CreateGroupLoading
                      ? null
                      : () => cubit.createGroup(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
