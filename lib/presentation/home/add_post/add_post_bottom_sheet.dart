import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/home/add_post/add_post_header.dart';
import 'package:auth/presentation/home/add_post/media_buttons_row.dart';
import 'package:auth/presentation/home/add_post/post_input_field.dart';
import 'package:auth/presentation/home/add_post/privacy_selector.dart';
import 'package:auth/presentation/home/add_post/selected_media_preview.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/manager/post_cubit/create_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddPostBottomSheet extends StatefulWidget {
  const AddPostBottomSheet({super.key});

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
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final maxHeight = mediaQuery.size.height * 0.8;

    return BlocProvider(
      create: (context) => di.sl<CreatePostCubit>(),
      child: BlocConsumer<CreatePostCubit, CreatePostState>(
        listener: (context, state) {
          if (state is CreatePostSuccess) {
            context.pop(state.createdPost);
            showCustomSnackBar(context, "Post created successfully!", true);
          }
          if (state is CreatePostError) {
            showCustomSnackBar(context, state.message, false);
          }
        },
        builder: (context, state) {
          final cubit = context.read<CreatePostCubit>();

          List<XFile> currentMedia = cubit.currentMedia;
          String currentPrivacy = cubit.currentPrivacy;
          bool isButtonEnabled = false;

          if (state is CreatePostEditing) {
            currentMedia = state.selectedMedia;
            currentPrivacy = state.privacy;
            isButtonEnabled = state.isPostButtonEnabled;
          }

          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Container(
              height: maxHeight,
              decoration:  BoxDecoration(
                color:Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: cubit.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AddPostHeader(
                            isPostEnabled:
                                isButtonEnabled,
                            onPost: () {
                              cubit.submitPost(
                                userId: "curr_user_id",
                              );
                            },
                          ),

                          PostInputField(
                            controller: _postController,
                            onChanged: (text) =>
                                cubit.updateText(text),
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
                                  false,
                                  onPicked: (files) {
                                    cubit.addMedia(files);
                                  },
                                ),
                            onPickVideo: () =>
                                BottomSheetManager.showMediaSourceSheet(
                                  context,
                                  true,
                                  onPicked: (files) {
                                    cubit.addMedia(files);
                                  },
                                ),
                          ),

                          PrivacySelector(
                            privacy: currentPrivacy,
                            onChange: (value) => cubit.updatePrivacy(value),
                          ),
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
