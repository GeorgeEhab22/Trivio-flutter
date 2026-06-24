import 'dart:io';
import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/constants/paths.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/chat.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/follow_button.dart';
import 'package:auth/presentation/manager/chat_cubit/chats_cubit.dart';
import 'package:auth/presentation/manager/chat_cubit/chats_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/user/widgets/profile_social_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class ProfileInfoBox extends StatelessWidget {
  final UserProfile user;

  const ProfileInfoBox({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String targetUserId = user.id;
    bool isCurrentUser = false;
    String loggedInUserId = "";

    final state = context.read<ProfileCubit>().state;
    if (state is ProfileLoaded) {
      loggedInUserId = state.user.id;
      isCurrentUser = loggedInUserId == targetUserId;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.lightGrey,
                backgroundImage: user.avatar.startsWith('http')
                    ? NetworkImage(user.avatar)
                    : (user.avatar.isNotEmpty)
                    ? FileImage(File(user.avatar)) as ImageProvider
                    : null,
                child: user.avatar.isEmpty
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            user.name,
            style: Styles.textStyle23.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          if (user.bio?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                user.bio!,
                textAlign: TextAlign.center,
                style: Styles.textStyle16.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is ProfileLoaded)
                SizedBox(
                  width: 180,
                  height: 44,
                  child: isCurrentUser
                      ? CustomSquareButton(
                          label: l10n.editProfile,
                          backgroundColor: AppColors.primary,
                          textColor: Colors.white,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                          borderRadius: 10,
                          height: 10,
                          row: true,
                          leadingIcon: Icons.edit,
                          iconColor: Colors.white,
                          onTap: () {
                            GoRouter.of(context).push(AppRoutes.editProfile);
                          },
                        )
                      : FollowButton(
                          currentUserId: loggedInUserId,
                          authorId: targetUserId,
                          isFollowing: user.isFollowing,
                        ),
                ),
              const SizedBox(width: 12),
              if (!isCurrentUser) ...[
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:IconButton(
                    icon: SizedBox(
                      width: 20,
                      height: 20,
                      child: SvgPicture.asset(
                        Paths.chatsIcon,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final chatsCubit = context.read<ChatsCubit>();

                      if (chatsCubit.state is! ChatsLoaded) {
                        await chatsCubit.loadChats(currentUserId: loggedInUserId);
                      }

                      Chat? existingChat;
                      if (chatsCubit.state is ChatsLoaded) {
                        final chats = (chatsCubit.state as ChatsLoaded).chats;
                        try {
                          existingChat = chats.firstWhere(
                            (c) => c.participantId == user.id,
                          );
                        } catch (_) {
                          existingChat = null; 
                        }
                      }

                      if (existingChat != null) {
                        context.push(
                          '/app/messages/chat/${existingChat.chatId}/${user.id}/${user.name}',
                        );
                      } else {
                        final result = await chatsCubit.getOrCreateConversation(
                            targetUserId: user.id);

                        result.fold(
                          (failure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(failure.message)),
                            );
                          },
                          (chat) {
                            context.push(
                              '/app/messages/chat/${chat.chatId}/${user.id}/${user.name}',
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {
                    final String profileUrl =
                        "https://trivio.app/profile/${user.name}";
                    SharePlus.instance.share(
                      ShareParams(
                        text: 'Check out this profile on Trivio!\n$profileUrl',
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.share,
                    color: Theme.of(context).iconTheme.color,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ProfileSocialInfo(
            numberOfFollowers: user.followersCount,
            numberOfFollowing: user.followingCount,
            numberOfPosts: user.postsCount,
            userId: isCurrentUser ? null : user.id,
          ),
        ],
      ),
    );
  }
}
