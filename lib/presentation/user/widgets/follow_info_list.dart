import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';
import 'package:flutter/material.dart';

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
    if (data.isEmpty) {
      return const Center(child: Text("No users found.", style: Styles.textStyle20));
    }

    return ListView.builder(
      itemCount: hasReachedMax ? data.length : data.length + 1,
      itemBuilder: (context, index) {
        if (index >= data.length) {
          onLoadMore?.call();
          return const Center(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ));
        }

        final item = data[index];
        
        // --- Mapping both types to the same UI variables ---
        String name;
        String? avatar;
        String id;

        if (item is Follow) {
          final targetRef = isFollowingList ? item.user : item.follower;
          name = targetRef.preview?.name ?? "User";
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
          title: Text(name, style: Styles.textStyle20),
          subtitle: Text("@${id.length > 8 ? id.substring(0, 8) : id}", style: const TextStyle(color: Colors.grey)),
          trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
          onTap: () {
            // Navigate to profile using 'id'
          },
        );
      },
    );
  }
}