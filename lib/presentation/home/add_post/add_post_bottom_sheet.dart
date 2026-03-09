import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/home/add_post/add_post_header.dart';
import 'package:auth/presentation/home/add_post/media_buttons_row.dart';
import 'package:auth/presentation/home/add_post/post_input_field.dart';
import 'package:auth/presentation/home/add_post/privacy_selector.dart';
import 'package:auth/presentation/home/add_post/selected_media_preview.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/manager/post_cubit/create_post_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auth/l10n/app_localizations.dart';

class AddPostBottomSheet extends StatefulWidget {
  final String? groupId;
  const AddPostBottomSheet({super.key, this.groupId});

  @override
  State<AddPostBottomSheet> createState() => _AddPostBottomSheetState();
}

class _AddPostBottomSheetState extends State<AddPostBottomSheet> {
  final TextEditingController _postController = TextEditingController();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    
    // Handle keyboard overlap
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final maxHeight = mediaQuery.size.height * 0.9; 

    return BlocProvider(
      create: (context) => di.sl<CreatePostCubit>(),
      child: BlocConsumer<CreatePostCubit, CreatePostState>(
        listener: (context, state) {
          if (state is CreatePostSuccess) {
            // Close the bottom sheet and return the new post
            context.pop(state.createdPost);
            showCustomSnackBar(context, l10n.postCreatedSuccess, true);
          }
          if (state is CreatePostError) {
            // state.message should be mapped to an l10n key in your listener logic if needed
            showCustomSnackBar(context, state.message, false);
          }
        },
        builder: (context, state) {
          final cubit = context.read<CreatePostCubit>();

          // Default values
          List<XFile> currentMedia = cubit.currentMedia;
          String currentPrivacy = cubit.currentPrivacy;
          bool isButtonEnabled = false;

          // Update values if state is Editing
          if (state is CreatePostEditing) {
            currentMedia = state.selectedMedia;
            currentPrivacy = state.privacy;
            isButtonEnabled = state.isPostButtonEnabled;
          }

          return Padding(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Container(
              constraints: BoxConstraints(maxHeight: maxHeight),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: cubit.isLoading
                  ? const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AddPostHeader(
                            isPostEnabled: isButtonEnabled,
                            onPost: () {
                              final state = context.read<ProfileCubit>().state;
                              String userId = '';
                              if (state is ProfileLoaded) {
                                userId = state.user.id;
                              }
                              cubit.submitPost(userId: userId, groupId: widget.groupId);
                            },
                          ),
                          PostInputField(
                            controller: _postController,
                            onChanged: (text) => cubit.updateText(text),
                          ),
                          if (currentMedia.isNotEmpty)
                            SelectedMediaPreview(
                              files: currentMedia,
                              onRemove: (index) {
                                cubit.removeMedia(index);
                              },
                            ),
                          MediaButtonsRow(
                            onPickImage: () =>
                                BottomSheetManager.showMediaSourceSheet(
                                  context,
                                  false, // isVideo = false
                                  onPicked: (files) {
                                    cubit.addMedia(files);
                                  },
                                ),
                            onPickVideo: () =>
                                BottomSheetManager.showMediaSourceSheet(
                                  context,
                                  true, // isVideo = true
                                  onPicked: (files) {
                                    cubit.addMedia(files);
                                  },
                                ),
                          ),
                          if(widget.groupId == null)
                          PrivacySelector(
                            privacy: currentPrivacy,
                            onChange: (value) => cubit.updatePrivacy(value),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}