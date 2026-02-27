import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'widgets/lists/comments_list.dart';

class CommentsBlocConsumer extends StatelessWidget {
  final String currentUserId;

  const CommentsBlocConsumer({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<CommentCubit, CommentState>(
      listener: (context, state) {
        if (state is CommentActionError) {
          // Map the key from Cubit to localized string
          String errorMessage = _mapErrorToMessage(state.message, l10n);
          showCustomSnackBar(context, errorMessage, false);
        }
        
        if (state is CommentActionSuccess) {
          String successMessage = _mapSuccessToMessage(state.message, l10n);
          showCustomSnackBar(context, successMessage, true);
        }
      },
      buildWhen: (previous, current) {
        return current is CommentLoaded ||
               current is CommentLoading ||
               current is CommentError;
      },
      builder: (context, state) {
        if (state is CommentLoading) {
          return Skeletonizer(
            child: CommentsList(
              comments: state.comments,
              currentUserId: currentUserId,
              onReplyTap: (_) {},
            ),
          );
        } else if (state is CommentError) {
          return Center(
            child: Text(
              _mapErrorToMessage(state.message, l10n),
              style: const TextStyle(color: Colors.grey),
            ),
          );
        } else if (state is CommentLoaded) {
          if (state.comments.isEmpty) {
            return Center(child: Text(l10n.noCommentsYet)); 
          }
          return CommentsList(
            comments: state.comments,
            currentUserId: currentUserId,
            onReplyTap: (comment) {
              context.read<CommentCubit>().triggerReply(comment);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // --- Helper Mapping Functions ---

  String _mapErrorToMessage(String key, AppLocalizations l10n) {
    switch (key) {
      case "load_failed": return l10n.commentLoadError;
      case "add_failed": return l10n.commentAddError;
      case "delete_failed": return l10n.commentDeleteError;
      case "update_failed": return l10n.unexpected_error;
      case "report_failed": return l10n.unexpected_error;
      default: return key.isEmpty ? l10n.unexpected_error : key;
    }
  }

  String _mapSuccessToMessage(String key, AppLocalizations l10n) {
    switch (key) {
      case "added": return l10n.commentAdded;
      case "updated": return l10n.commentUpdated;
      case "deleted": return l10n.commentDeleted;
      case "reported": return l10n.commentReported;
      case "hidden": return l10n.commentHidden;
      default: return "";
    }
  }
}
