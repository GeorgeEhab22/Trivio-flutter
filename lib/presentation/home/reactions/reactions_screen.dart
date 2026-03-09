import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/common/functions/number_extensions.dart';
import 'package:auth/domain/usecases/comment/get_comment_reactions_usecase.dart';
import 'package:auth/domain/usecases/post/get_post_reactions_usecase.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ReactionsScreen extends StatefulWidget {
  final List<Reaction>? initialReactions;
  final String? postId;
  final String? commentId;
  final String? currentUserId;

  const ReactionsScreen({
    super.key,
    required List<Reaction> reactions,
    this.currentUserId,
  })
    : initialReactions = reactions,
      postId = null,
      commentId = null;

  const ReactionsScreen.forPost({
    super.key,
    required this.postId,
    this.currentUserId,
  }) : initialReactions = null,
       commentId = null;

  const ReactionsScreen.forComment({
    super.key,
    required this.commentId,
    this.currentUserId,
  }) : initialReactions = null,
       postId = null;

  @override
  State<ReactionsScreen> createState() => _ReactionsScreenState();
}

class _ReactionsScreenState extends State<ReactionsScreen> {
  late final Future<List<Reaction>> _reactionsFuture;

  static const List<ReactionType> _reactionOrder = [
    ReactionType.like,
    ReactionType.love,
    ReactionType.haha,
    ReactionType.wow,
    ReactionType.sad,
    ReactionType.angry,
    ReactionType.goal,
    ReactionType.offside,
  ];

  @override
  void initState() {
    super.initState();
    _reactionsFuture = _loadReactions();
  }

  Future<List<Reaction>> _loadReactions() async {
    if (widget.postId == null && widget.commentId == null) {
      return widget.initialReactions ?? const [];
    }
    if (widget.postId != null) {
      final postId = widget.postId!.trim();
      if (postId.isEmpty) {
        return const [];
      }
      final result = await di.sl<GetPostReactionsUseCase>()(
        postId: postId,
      );
      return result.fold(
        (failure) => throw Exception(failure.message),
        (fetched) => fetched,
      );
    }

    final commentId = widget.commentId!.trim();
    if (commentId.isEmpty) {
      return const [];
    }
    final result = await di.sl<GetCommentReactionsUseCase>()(
      commentId: commentId,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (fetched) => fetched,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<List<Reaction>>(
      future: _reactionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(),
              title: Text(l10n.reactionsTitle),
            ),
            body: Center(child: Text(l10n.loading)),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(),
              title: Text(l10n.reactionsTitle),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.reactionsLoadError,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final reactions = snapshot.data ?? const <Reaction>[];
        final reactionsByType = <ReactionType, List<Reaction>>{};
        for (final reaction in reactions) {
          if (reaction.type == ReactionType.none) {
            continue;
          }
          reactionsByType.putIfAbsent(reaction.type, () => <Reaction>[]);
          reactionsByType[reaction.type]!.add(reaction);
        }

        final sortedTypes = reactionsByType.keys.toList()
          ..sort((a, b) {
            final byCount = reactionsByType[b]!.length.compareTo(
              reactionsByType[a]!.length,
            );
            if (byCount != 0) {
              return byCount;
            }
            return _reactionOrder.indexOf(a).compareTo(_reactionOrder.indexOf(b));
          });

        return DefaultTabController(
          length: sortedTypes.length + 1,
          child: ScrollConfiguration(
            behavior: const _WebDragScrollBehavior(),
            child: Scaffold(
              appBar: AppBar(
                leading: const BackButton(),
                title: Text(l10n.reactionsTitle),
                bottom: TabBar(
                  isScrollable: true,
                  physics: const BouncingScrollPhysics(),
                  tabs: [
                    Tab(
                      text:
                          '${l10n.reactionsTabAll} ${reactions.length.toString().localizeDigits(context)}',
                    ),
                    ...sortedTypes.map(
                      (type) => Tab(
                        text:
                            '${_emoji(type)} ${reactionsByType[type]!.length.toString().localizeDigits(context)}',
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  _ReactionUsersList(
                    reactions: reactions,
                    emptyText: l10n.reactionsEmptyAll,
                    currentUserId: widget.currentUserId,
                  ),
                  ...sortedTypes.map(
                    (type) => _ReactionUsersList(
                      reactions: reactionsByType[type]!,
                      emptyText: l10n.reactionsEmptyType,
                      currentUserId: widget.currentUserId,
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

  static String _emoji(ReactionType type) {
    switch (type) {
      case ReactionType.like:
        return '👍';
      case ReactionType.love:
        return '❤️';
      case ReactionType.haha:
        return '😂';
      case ReactionType.wow:
        return '😮';
      case ReactionType.sad:
        return '😢';
      case ReactionType.angry:
        return '😡';
      case ReactionType.goal:
        return '⚽';
      case ReactionType.offside:
        return '🚩';
      case ReactionType.none:
        return '';
    }
  }

}

class _WebDragScrollBehavior extends MaterialScrollBehavior {
  const _WebDragScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.unknown,
  };
}

class _ReactionUsersList extends StatelessWidget {
  final List<Reaction> reactions;
  final String emptyText;
  final String? currentUserId;

  const _ReactionUsersList({
    required this.reactions,
    required this.emptyText,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            emptyText,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: reactions.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final reaction = reactions[index];
        final emoji = _ReactionsScreenState._emoji(reaction.type);
        final username = reaction.username?.trim();
        final isCurrentUser =
            currentUserId != null &&
            currentUserId!.trim().isNotEmpty &&
            reaction.userId == currentUserId;
        final resolvedName = isCurrentUser
            ? AppLocalizations.of(context)!.reactionsYou
            : ((username == null || username.isEmpty)
                  ? reaction.userId
                  : username);
        final profilePicture = reaction.profilePicture?.trim();
        final hasProfilePicture =
            profilePicture != null && profilePicture.isNotEmpty;
        return ListTile(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: hasProfilePicture
                      ? NetworkImage(profilePicture)
                      : null,
                  child: hasProfilePicture
                      ? null
                      : const Icon(Icons.person, size: 20),
                ),
                PositionedDirectional(
                  end: -2,
                  bottom: -2,
                  child: Text(emoji, style: const TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
          title: Text(resolvedName),
        );
      },
    );
  }
}
