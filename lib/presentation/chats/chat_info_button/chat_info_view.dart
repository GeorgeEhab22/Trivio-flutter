import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/manager/profile_cubit/get_user_profile_by_id_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/get_user_profile_by_id_state.dart';
import 'package:flutter/material.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatInfoView extends StatelessWidget {
  final String userId;
  final String targetUserName;
  final String conversationId;
  const ChatInfoView({
    super.key,
    required this.userId,
    required this.targetUserName,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<GetUserProfileByIdCubit, GetUserProfileByIdState>(
      builder: (context, state) {
        if (state is GetUserProfileByIdLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = (state is GetUserProfileByIdLoaded) ? state.user : null;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => context.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutes.userProfileByIdPath(userId ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: (user?.avatar.isNotEmpty ?? false)
                          ? NetworkImage(user!.avatar)
                          : null,
                      child: (user?.avatar.isEmpty ?? true)
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutes.userProfileByIdPath(userId),
                    );
                  },
                  child: Text(
                    user?.name ?? targetUserName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.online,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 25),

                
                _buildSectionContainer(
                  context,
                  title: l10n.information,
                  children: [
                    _buildInfoTile(
                      l10n.email,
                      user?.email ?? l10n.noEmailProvided,
                    ),
                    _buildInfoTile(l10n.bio, user?.bio ?? l10n.noBioAvailable),
                  ],
                ),

               
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionContainer(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 16,
              right: 16,
              bottom: 8,
            ),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
