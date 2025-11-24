import 'package:auth/constants/colors';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/home/add_post/add_post_header.dart';
import 'package:auth/presentation/home/add_post/media_buttons_row.dart';
import 'package:auth/presentation/home/add_post/post_input_field.dart';
import 'package:auth/presentation/home/add_post/privacy_selector.dart';
import 'package:auth/presentation/home/add_post/selected_media_preview.dart';
import 'package:auth/presentation/home/add_post/tag_input_section.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostBottomSheet extends StatefulWidget {
  const AddPostBottomSheet({super.key});

  @override
  State<AddPostBottomSheet> createState() => _AddPostBottomSheetState();
}

class _AddPostBottomSheetState extends State<AddPostBottomSheet> {
  final TextEditingController _postController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final List<XFile> _selectedMedia = [];
  String _privacy = "Public";

  Future<void> _pickMedia({
    required bool isVideo,
    required bool fromCamera,
  }) async {
    try {
      if (isVideo) {
        final XFile? pickedVideo = await _picker.pickVideo(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        );
        if (pickedVideo != null) {
          setState(() {
            _selectedMedia.add(pickedVideo);
          });
        }
      } else {
        final List<XFile> pickedImages = fromCamera
            ? [
                await _picker.pickImage(source: ImageSource.camera),
              ].whereType<XFile>().toList()
            : await _picker.pickMultiImage();

        if (pickedImages.isNotEmpty) {
          setState(() {
            _selectedMedia.addAll(pickedImages);
          });
        }
      }
    } catch (e) {
      // print("Error picking media: $e");
    }
  }

  void _showMediaSourceSheet(bool isVideo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.iconsColor,
                ),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(isVideo: isVideo, fromCamera: false);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: AppColors.iconsColor,
                ),
                title: const Text("Use Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(isVideo: isVideo, fromCamera: true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
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
                  onRemove: (index) {
                    setState(() {
                      _selectedMedia.removeAt(index);
                    });
                  },
                ),

              MediaButtonsRow(
                onPickImage: () => _showMediaSourceSheet(false),
                onPickVideo: () => _showMediaSourceSheet(true),
              ),

              TagInputSection(),

              PrivacySelector(
                privacy: _privacy,
                onChange: (value) => setState(() => _privacy = value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
