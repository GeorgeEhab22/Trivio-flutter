import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_update_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_update_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Extract the initial state once to prevent text from resetting during rebuilds
    final cubit = context.read<ProfileUpdateCubit>();
    String initialName = "";
    String initialBio = "";

    if (cubit.state is ProfileUpdateInitialState) {
      final state = cubit.state as ProfileUpdateInitialState;
      initialName = state.name;
      initialBio = state.bio;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        titleTextStyle: Styles.textStyle20.copyWith(color: Colors.black),
      ),
      body: BlocListener<ProfileUpdateCubit, ProfileUpdateState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            context.read<ProfileCubit>().loadProfile();
            context.go(AppRoutes.profile);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar Section
              BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                buildWhen: (prev, curr) => curr is ProfileUpdateInitialState,
                builder: (context, state) {
                  // 1. Get the local file from the UpdateCubit state (if picked)
                  final File? localImage = state is ProfileUpdateInitialState
                      ? state.image
                      : null;

                  // 2. Get the original network image from the global ProfileCubit
                  final profileState = context.read<ProfileCubit>().state;
                  String? originalImageUrl;
                  if (profileState is ProfileLoaded) {
                    originalImageUrl = profileState
                        .user
                        .avatar; // Accessing your UserProfile entity
                  }

                  return GestureDetector(
                    onTap: () async {
                      final file = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (file != null) {
                        context.read<ProfileUpdateCubit>().updateImage(
                          File(file.path),
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.lightGrey,
                          // 💡 Check if we have a new local file first, otherwise use the helper
                          backgroundImage: localImage != null
                              ? FileImage(localImage)
                              : (originalImageUrl != null &&
                                    originalImageUrl.isNotEmpty)
                              ? _getProfileImage(
                                  originalImageUrl,
                                ) // Use the smart helper here!
                              : null,
                          child:
                              (localImage == null &&
                                  (originalImageUrl == null ||
                                      originalImageUrl.isEmpty))
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey,
                                )
                              : null,
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
                  );
                },
              ),
              const SizedBox(height: 30),

              // Username Field
              TextFormField(
                initialValue: initialName,
                cursorColor: AppColors.primary,
                decoration: _buildInputDecoration(
                  "Username",
                  Icons.person_outline,
                ),
                onChanged: (val) =>
                    context.read<ProfileUpdateCubit>().onInfoChanged(name: val),
              ),
              const SizedBox(height: 20),

              // Bio Field
              TextFormField(
                initialValue: initialBio,
                cursorColor: AppColors.primary,
                maxLines: 3,
                decoration: _buildInputDecoration(
                  "Bio",
                  Icons.description_outlined,
                ),
                onChanged: (val) =>
                    context.read<ProfileUpdateCubit>().onInfoChanged(bio: val),
              ),
              const SizedBox(height: 40),

              // Save Button
              BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: state is ProfileUpdateLoading
                        ? null
                        : () =>
                              context.read<ProfileUpdateCubit>().submitUpdate(),
                    child: state is ProfileUpdateLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save Changes",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for consistent styling
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

  ImageProvider _getProfileImage(String avatarPath) {
    if (avatarPath.startsWith('http') || avatarPath.startsWith('https')) {
      return NetworkImage(avatarPath);
    } else {
      // If it's a local path like /home/menna/... or /data/user/0/...
      return FileImage(File(avatarPath));
    }
  }
}
