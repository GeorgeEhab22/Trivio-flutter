import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/domain/usecases/comment/get_comment_reactions_usecase.dart';
import 'package:auth/domain/usecases/post/get_post_reactions_usecase.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/reaction_users_list.dart';
import 'widgets/reaction_tab_bar.dart';

class ReactionsScreen extends StatefulWidget {
  final List<Reaction>? initialReactions;
  final String? postId;
  final String? commentId;
  final String? currentUserId;

  const ReactionsScreen({
    super.key,
    required List<Reaction> reactions,
    this.currentUserId,
  }) : initialReactions = reactions,
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
      if (postId.isEmpty) return const [];
      final result = await di.sl<GetPostReactionsUseCase>()(postId: postId);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (fetched) => fetched,
      );
    }

    final commentId = widget.commentId!.trim();
    if (commentId.isEmpty) return const [];
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<List<Reaction>>(
      future: _reactionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(),
              title: Text(
                l10n.reactionsTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            body: Center(child: Text(l10n.loading)),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(),
              title: Text(
                l10n.reactionsTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.reactionsLoadError,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final reactions = snapshot.data ?? const <Reaction>[];
        final reactionsByType = <ReactionType, List<Reaction>>{};
        for (final reaction in reactions) {
          if (reaction.type == ReactionType.none) continue;
          reactionsByType.putIfAbsent(reaction.type, () => <Reaction>[]);
          reactionsByType[reaction.type]!.add(reaction);
        }

        final sortedTypes = reactionsByType.keys.toList()
          ..sort((a, b) {
            final byCount = reactionsByType[b]!.length.compareTo(
              reactionsByType[a]!.length,
            );
            if (byCount != 0) return byCount;
            return _reactionOrder
                .indexOf(a)
                .compareTo(_reactionOrder.indexOf(b));
          });

        return DefaultTabController(
          length: sortedTypes.length + 1,
          child: ScrollConfiguration(
            behavior: const _WebDragScrollBehavior(),
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  l10n.reactionsTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                elevation: 0,
                scrolledUnderElevation: 0,
                bottom: ReactionTabBar(
                  totalReactionsCount: reactions.length,
                  sortedTypes: sortedTypes,
                  reactionsByType: reactionsByType,
                ),
              ),
              body: TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  ReactionUsersList(
                    reactions: reactions,
                    emptyText: l10n.reactionsEmptyAll,
                    currentUserId: widget.currentUserId,
                  ),
                  ...sortedTypes.map(
                    (type) => ReactionUsersList(
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