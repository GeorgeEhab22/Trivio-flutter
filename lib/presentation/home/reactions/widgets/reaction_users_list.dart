import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/reactions/widgets/reaction_type_extention.dart';
import 'package:auth/presentation/home/reactions/widgets/render_reactions.dart';
import 'package:flutter/material.dart';
class ReactionUsersList extends StatelessWidget {
  final List<Reaction> reactions;
  final String emptyText;
  final String? currentUserId;

  const ReactionUsersList({
    super.key,
    required this.reactions,
    required this.emptyText,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (reactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            emptyText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: reactions.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final reaction = reactions[index];
        final emojiPath = reaction.type.emojiPath;
        final username = reaction.username?.trim();
        final isCurrentUser = currentUserId != null &&
            currentUserId!.trim().isNotEmpty &&
            reaction.userId == currentUserId;
        
        final resolvedName = isCurrentUser
            ? AppLocalizations.of(context)!.reactionsYou
            : ((username == null || username.isEmpty) ? reaction.userId : username);
        
        final profilePicture = reaction.profilePicture?.trim();
        final hasProfilePicture = profilePicture != null && profilePicture.isNotEmpty;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: InkWell(
            onTap: () {
              //TODO: go to user's profile
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] :  Colors.grey[150] , 
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.grey[800]! : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                            backgroundImage: hasProfilePicture ? NetworkImage(profilePicture) : null,
                            child: hasProfilePicture ? null : Icon(Icons.person, size: 24, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                          ),
                        ),
                        if (emojiPath.isNotEmpty)
                          PositionedDirectional(
                            end: -2,
                            bottom: -2,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[900] : Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ReactionEmoji(path: emojiPath, size: 16),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      resolvedName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600, 
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
}