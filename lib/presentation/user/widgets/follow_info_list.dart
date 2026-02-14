import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/follow.dart';
import 'package:flutter/material.dart';

class FollowInfoList extends StatelessWidget {
  final List data;
  final VoidCallback? onLoadMore;
  final bool hasReachedMax;
  final bool isFollowingList; // true if we are looking at who the user IS FOLLOWING

  const FollowInfoList({
    super.key,
    required this.data,
    required this.isFollowingList,
    this.onLoadMore,
    this.hasReachedMax = true,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No users found."));
    }

    return ListView.builder(
      itemCount: hasReachedMax ? data.length : data.length + 1,
      itemBuilder: (context, index) {
        if (index >= data.length) {
          onLoadMore?.call();
          return const Center(child: CircularProgressIndicator());
        }

        final followItem = data[index];
        
        // MAPPING LOGIC BASED ON BACKEND DOCS:
        // If showing "Following" (Endpoint 9), the person you follow is in 'userId'
        // If showing "Followers" (Endpoint 8), the person following you is in 'followerId'
        final UserReference targetRef = isFollowingList 
            ? followItem.user 
            : followItem.follower;

        final String displayName = targetRef.preview?.name ?? "User ${targetRef.id}";
        final String? avatar = targetRef.preview?.avatarUrl;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.lightGrey,
            backgroundImage: avatar != null ? NetworkImage(avatar) : null,
            child: avatar == null ? const Icon(Icons.person, color: Colors.grey) : null,
          ),
          title: Text(displayName, style: Styles.textStyle20),
          subtitle: Text(targetRef.preview != null ? "@${targetRef.id.substring(0,5)}" : ""),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
             // Navigate to profile using targetRef.id
          },
        );
      },
    );
  }
}