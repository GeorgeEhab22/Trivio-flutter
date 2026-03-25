import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_update_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_update_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      builder: (context, state) {
        // Default fallback values
        String name = "";
        String bio = "";
        XFile? localImage;
        String originalAvatar = "";

        // Extract data only if we are in the initial/editing state
        if (state is ProfileUpdateInitialState) {
          name = state.name;
          bio = state.bio;
          localImage = state.image;
          originalAvatar = state.originalAvatar;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.editProfile),
            centerTitle: true,
            titleTextStyle: Styles.textStyle20.copyWith(color: Colors.black),
          ),
          body: BlocListener<ProfileUpdateCubit, ProfileUpdateState>(
            listener: (context, state) {
              if (state is ProfileUpdateSuccess) {
                context.read<ProfileCubit>().loadProfile();
                context.go(AppRoutes.profile);
              } else if (state is ProfileUpdateError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // --- Avatar Section ---
                  GestureDetector(
                    onTap: () async {
                      final file = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (file != null) {
                        context.read<ProfileUpdateCubit>().updateImage(file);
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors
                                .lightGrey, // This is your "Gray" background
                          ),
                          child: ClipOval(
                            child: _buildAvatarContent(
                              localImage,
                              originalAvatar,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- Username Field ---
                  TextFormField(
                    key: const Key(
                      'name_field',
                    ), // Using keys prevents text reset bugs
                    initialValue: name,
                    cursorColor: AppColors.primary,
                    decoration: _buildInputDecoration(
                      l10n.username,
                      Icons.person_outline,
                    ),
                    onChanged: (val) => context
                        .read<ProfileUpdateCubit>()
                        .onInfoChanged(name: val),
                  ),
                  const SizedBox(height: 20),

                  // --- Bio Field ---
                  TextFormField(
                    key: const Key('bio_field'),
                    initialValue: bio,
                    cursorColor: AppColors.primary,
                    maxLines: 3,
                    maxLength: 120,
                    decoration: _buildInputDecoration(
                      l10n.bioLabel,
                      Icons.description_outlined,
                    ),
                    onChanged: (val) => context
                        .read<ProfileUpdateCubit>()
                        .onInfoChanged(bio: val),
                  ),
                  const SizedBox(height: 40),

                  // --- Save Button ---
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: state is ProfileUpdateLoading
                        ? null
                        : () =>
                              context.read<ProfileUpdateCubit>().submitUpdate(),
                    child: state is ProfileUpdateLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            l10n.saveChanges,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      labelStyle: const TextStyle(color: Colors.grey),
      floatingLabelStyle: const TextStyle(color: AppColors.primary),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightGrey),
      ),
    );
  }

  Widget _buildAvatarContent(XFile? localImage, String originalAvatar) {
    // 1. Show newly picked local image immediately
    if (localImage != null) {
      return kIsWeb
          ? Image.network(
              localImage.path,
              fit: BoxFit.cover,
              width: 120,
              height: 120,
            )
          : Image.file(
              File(localImage.path),
              fit: BoxFit.cover,
              width: 120,
              height: 120,
            );
    }

    // 2. Show network image if URL exists
    if (originalAvatar.isNotEmpty && originalAvatar.startsWith('http')) {
      return Image.network(
        originalAvatar,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        // If the URL is broken or 404s, show the icon
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, size: 60, color: Colors.grey),
        // Optional: Show a tiny spinner while it's downloading
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
      );
    }

    // 3. Fallback for empty/invalid URLs
    return const Icon(Icons.person, size: 60, color: Colors.grey);
  }
}
