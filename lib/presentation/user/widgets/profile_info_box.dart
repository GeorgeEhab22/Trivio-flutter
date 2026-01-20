import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/user/widgets/profile_social_info.dart';
import 'package:flutter/material.dart';

class ProfileInfoBox extends StatelessWidget {
  final String username;
  final String userAbout;
  final String? avatarUrl;

  const ProfileInfoBox({
    super.key,
    this.username = "Username",
    this.userAbout = "about",
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final double avatarSize = MediaQuery.of(context).size.height * 0.12;

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar + Username (top aligned)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    /// Avatar
                    CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundColor: Colors.black,
                      backgroundImage:
                          avatarUrl != null && avatarUrl!.isNotEmpty
                          ? NetworkImage(avatarUrl!)
                          : null,
                      child: (avatarUrl == null || avatarUrl!.isEmpty)
                          ? Text(
                              username[0].toUpperCase(),
                              style: Styles.textStyle25.copyWith(
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),

                    /// Small circular button
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Material(
                        color: AppColors.primary,
                        shape: const CircleBorder(),
                        elevation: 2,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            // TODO: handle follow of the profile
                          },
                          child: const SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              /// Username aligned to top of avatar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        username.length > 16
                            ? username.substring(0, 16)
                            : username,
                        style: username.length <= 10
                            ? Styles.textStyle25
                            : Styles.textStyle20,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ProfileSocialInfo(),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// About text (under both)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              userAbout,
              style: const TextStyle(fontSize: 18),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
