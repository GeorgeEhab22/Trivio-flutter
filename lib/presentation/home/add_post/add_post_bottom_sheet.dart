import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/home/add_post/add_post_header.dart';
import 'package:auth/presentation/home/add_post/media_buttons_row.dart';
import 'package:auth/presentation/home/add_post/post_input_field.dart';
import 'package:auth/presentation/home/add_post/privacy_selector.dart';
import 'package:auth/presentation/home/add_post/selected_media_preview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostBottomSheet extends StatefulWidget {
  const AddPostBottomSheet({super.key});

  @override
  State<AddPostBottomSheet> createState() => _AddPostBottomSheetState();
}

class _AddPostBottomSheetState extends State<AddPostBottomSheet> {
  final TextEditingController _postController = TextEditingController();

  final List<XFile> _selectedMedia = [];
  String _privacy = "Public";

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final maxHeight = mediaQuery.size.height * 0.95;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        height: maxHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddPostHeader(
                onPost: () {
                  if (_postController.text.trim().isNotEmpty ||
                      _selectedMedia.isNotEmpty) {
                    Navigator.pop(context);
                    showCustomSnackBar(
                      context,
                      "Post created successfully!",
                      true,
                    );
                  }
                },
              ),
              PostInputField(controller: _postController),
              if (_selectedMedia.isNotEmpty)
                SelectedMediaPreview(
                  files: _selectedMedia,
                  onRemove: (path) {
                    if (!mounted) return;
                    setState(() {
                      _selectedMedia.removeWhere((file) => file.path == path);
                    });
                  },
                ),
              MediaButtonsRow(
                onPickImage: () => BottomSheetManager.showMediaSourceSheet(
                  context,
                  false,
                  onPicked: (files) {
                    if (!mounted) return;
                    setState(() {
                      _selectedMedia.addAll(files);
                    });
                  },
                ),
                onPickVideo: () => BottomSheetManager.showMediaSourceSheet(
                  context,
                  true,
                  onPicked: (files) {
                    if (!mounted) return;
                    setState(() {
                      _selectedMedia.addAll(files);
                    });
                  },
                ),
              ),
              PrivacySelector(
                privacy: _privacy,
                onChange: (value) {
                  if (!mounted) return;
                  setState(() => _privacy = value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
