import 'dart:ui';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCaptionField extends StatelessWidget {
  final TextEditingController controller;

  const AddCaptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = context.watch<ProfileCubit>().state;
    
    String? currentUserAvatar;
    if (profileState is ProfileLoaded) {
      currentUserAvatar = profileState.user.avatar; 
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end, 
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white24,
                backgroundImage: currentUserAvatar != null && currentUserAvatar.isNotEmpty
                    ? NetworkImage(currentUserAvatar)
                    : null,
                child: currentUserAvatar == null || currentUserAvatar.isEmpty
                    ? const Icon(Icons.person, size: 18, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: 4,
                  minLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: l10n.addPostHint,
                    hintStyle:const TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}