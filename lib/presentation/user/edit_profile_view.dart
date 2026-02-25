import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_update_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_update_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Grab initial values from the Cubit state for the text fields
    final cubit = context.read<ProfileUpdateCubit>();
    String initialName = "";
    String initialBio = "";

    if (cubit.state is ProfileUpdateInitialState) {
      initialName = (cubit.state as ProfileUpdateInitialState).name;
      initialBio = (cubit.state as ProfileUpdateInitialState).bio;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        titleTextStyle: Styles.textStyle20.copyWith(color: AppColors.primary),
      ),
      body: BlocListener<ProfileUpdateCubit, ProfileUpdateState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            // 2. Trigger Global Refresh so the main profile updates immediately
            context.read<ProfileCubit>().loadProfile();
            Navigator.pop(context);
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
                  final image = state is ProfileUpdateInitialState ? state.image : null;
                  return GestureDetector(
                    onTap: () async {
                      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (file != null) context.read<ProfileUpdateCubit>().updateImage(File(file.path));
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.lightGrey,
                      backgroundImage: image != null ? FileImage(image) : null,
                      child: image == null 
                          ? const Icon(Icons.camera_alt, color: AppColors.primary) 
                          : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Username Field
              TextFormField(
                initialValue: initialName, // 3. Pre-fill name
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: const TextStyle(color: Colors.grey),
                  floatingLabelStyle: const TextStyle(color: AppColors.primary),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                onChanged: (val) => context.read<ProfileUpdateCubit>().onInfoChanged(name: val),
              ),
              const SizedBox(height: 15),

              // Bio Field
              TextFormField(
                initialValue: initialBio, // 4. Pre-fill bio
                cursorColor: AppColors.primary,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Bio",
                  labelStyle: const TextStyle(color: Colors.grey),
                  floatingLabelStyle: const TextStyle(color: AppColors.primary),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                onChanged: (val) => context.read<ProfileUpdateCubit>().onInfoChanged(bio: val),
              ),
              const SizedBox(height: 30),

              // Save Button
              BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: state is ProfileUpdateLoading 
                        ? null 
                        : () => context.read<ProfileUpdateCubit>().submitUpdate(),
                    child: state is ProfileUpdateLoading 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text("Save Changes"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}