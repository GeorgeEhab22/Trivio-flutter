import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/follow_button.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FollowInfoList extends StatelessWidget {
  final List<dynamic> data;
  final bool isFollowingList;
  final VoidCallback? onLoadMore;
  final bool hasReachedMax;

  const FollowInfoList({
    super.key,
    required this.data,
    this.isFollowingList = false,
    this.onLoadMore,
    this.hasReachedMax = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = context.read<ProfileCubit>().state;
    String? currentUserId;
    if (profileState is ProfileLoaded) {
      currentUserId = profileState.user.id;
    }
    
    if (data.isEmpty) {
      return Center(child: Text(l10n.noUsersFound, style: Styles.textStyle20));
    }

    return ListView.builder(
      itemCount: hasReachedMax ? data.length : data.length + 1,
      itemBuilder: (context, index) {
        if (index >= data.length) {
          onLoadMore?.call();
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final item = data[index];

        String name;
        String? avatar;
        String id;

        if (item is Follow) {
          final targetRef = isFollowingList ? item.user : item.follower;
          name = targetRef.preview?.name ?? l10n.unknownUser;
          avatar = targetRef.preview?.avatarUrl;
          id = targetRef.id;
        } else if (item is UserProfilePreview) {
          name = item.name;
          avatar = item.avatarUrl;
          id = item.id;
        } else {
          return const SizedBox.shrink();
        }

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.lightGrey,
            backgroundImage: (avatar != null && avatar.isNotEmpty)
                ? NetworkImage(avatar)
                : null,
            child: (avatar == null || avatar.isEmpty)
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          title: Text(name, style: Styles.textStyle18),
          trailing: IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentUserId != null && currentUserId != id) 
                  BlocBuilder<ProfileSocialInfoCubit, ProfileSocialInfoState>(
                    builder: (context, socialState) {
                      bool amIFollowing = false; 
                      
                      if (socialState is SocialInfoLoaded) {
                         amIFollowing = socialState.following.any(
                           (f) => f.user.id.toString().trim() == id.toString().trim(),
                         );
                      }

                      return FollowButton(
                        currentUserId: currentUserId!,
                        authorId: id,
                        isFollowing: amIFollowing,
                        showUnfollowText: isFollowingList, 
                      );
                    },
                  ),
              ],
            ),
          ),
          onTap: () {
            context.push(AppRoutes.userProfileByIdPath(id));
          },
        );
      },
    );
  }
}