import 'package:auth/constants/colors.dart';
import 'package:auth/common/functions/number_extensions.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/home/comments/comments_bloc_consumer.dart';
import 'package:auth/presentation/home/comments/widgets/input_field/input_field_bloc_builder.dart';
import 'package:auth/presentation/home/reactions/reactions_screen.dart';
import 'package:auth/presentation/home/widgets/people_reacted.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/l10n/app_localizations.dart';

enum _CommentsSortOption { newest, mostRelated, mostReplied }

class CommentsView extends StatefulWidget {
  final String postId;
  final String currentUserId;
  final int sharesCount;
  final int reactionsCount;
  final List<ReactionType> topReactions;
  final bool isReelView;

  const CommentsView({
    super.key,
    required this.postId,
    required this.currentUserId,
    this.sharesCount = 0,
    this.reactionsCount = 0,
    this.topReactions = const <ReactionType>[],
    this.isReelView = false,
  });

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  _CommentsSortOption _selectedSort = _CommentsSortOption.newest;

  String _mapSortToQuery(_CommentsSortOption sort) {
    switch (sort) {
      case _CommentsSortOption.newest:
        return '-createdAt';
      case _CommentsSortOption.mostRelated:
        return '-reactionsCount';
      case _CommentsSortOption.mostReplied:
        return '-repliesCount';
    }
  }

  String _sortLabel(AppLocalizations l10n, _CommentsSortOption sort) {
    switch (sort) {
      case _CommentsSortOption.newest:
        return l10n.commentsSortNewest;
      case _CommentsSortOption.mostRelated:
        return l10n.commentsSortMostRelated;
      case _CommentsSortOption.mostReplied:
        return l10n.commentsSortMostReplied;
    }
  }

  Future<void> _loadComments() async {
    final commentCubit = context.read<CommentCubit>();
    await commentCubit.getComments(
      widget.postId,
      sort: _mapSortToQuery(_selectedSort),
    );
    if (!context.mounted) return;
    final state = context.read<ProfileCubit>().state;

    if (state is ProfileLoaded) {
      final userId = state.user.id;
      await commentCubit.hydrateCurrentUserReactions(
        currentUserId: userId,
      );
    }
  }

  Future<void> _onSortChanged(_CommentsSortOption? value) async {
    if (value == null || value == _selectedSort) {
      return;
    }
    setState(() {
      _selectedSort = value;
    });
    await _loadComments();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadComments();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<ProfileCubit>().state;
    String userId = '';
    if (state is ProfileLoaded) {
      userId = state.user.id;
    }
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.08);
    final shellGradient = isDark
        ? const [Color(0xFF1C2128), Color(0xFF151A20)]
        : const [Color(0xFFFFFFFF), Color(0xFFF7FBF8)];
    final metricsTextColor = isDark
        ? Colors.white.withValues(alpha: 0.88)
        : const Color(0xFF1F2937);
    final hasReactions = widget.reactionsCount > 0;

    return Container(
      height:
          MediaQuery.of(context).size.height *
          (widget.isReelView ? 0.65 : 0.95),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: shellGradient,
            ),
            border: Border.all(color: borderColor),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        if (hasReactions)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PeopleReacted(
                                color: AppColors.primary.withValues(
                                  alpha: isDark ? 0.98 : 0.9,
                                ),
                                topReactions: widget.topReactions,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ReactionsScreen.forPost(
                                        postId: widget.postId,
                                        currentUserId: userId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.reactionsCount
                                    .toString()
                                    .localizeDigits(context),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.86)
                                          : const Color(0xFF374151),
                                    ),
                              ),
                            ],
                          )
                        else
                          Flexible(
                            child: Text(
                              l10n.reactionsEncouragement,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.78)
                                        : const Color(0xFF4B5563),
                                  ),
                            ),
                          ),
                        if (hasReactions) const Spacer(),
                        if (!hasReactions) const SizedBox(width: 12),
                        _SharesMetric(
                          label:
                              '${widget.sharesCount.toString().localizeDigits(context)} ${l10n.shareLabel}',
                          color: metricsTextColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    height: 1,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : const Color(0xFFE5EBE8),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.swap_vert_rounded,
                          size: 18,
                          color: AppColors.primary.withValues(
                            alpha: isDark ? 0.95 : 0.85,
                          ),
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton<_CommentsSortOption>(
                          onSelected: (value) {
                            _onSortChanged(value);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: _CommentsSortOption.newest,
                              child: Text(l10n.commentsSortNewest),
                            ),
                            PopupMenuItem(
                              value: _CommentsSortOption.mostRelated,
                              child: Text(l10n.commentsSortMostRelated),
                            ),
                            PopupMenuItem(
                              value: _CommentsSortOption.mostReplied,
                              child: Text(l10n.commentsSortMostReplied),
                            ),
                          ],
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _sortLabel(l10n, _selectedSort),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 3),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CommentsBlocConsumer(
                      currentUserId: userId,
                    ),
                  ),
                  InputFieldBlocBuilder(
                    controller: _controller,
                    focusNode: _focusNode,
                    postId: widget.postId,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SharesMetric extends StatelessWidget {
  final String label;
  final Color color;

  const _SharesMetric({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.16),
            color.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.share_outlined, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
