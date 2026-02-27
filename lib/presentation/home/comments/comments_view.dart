import 'package:auth/core/styels.dart';
import 'package:auth/presentation/home/comments/comments_bloc_consumer.dart';
import 'package:auth/presentation/home/comments/widgets/input_field/input_field_bloc_builder.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/l10n/app_localizations.dart';

class CommentsView extends StatefulWidget {
  final String postId;
  final String currentUserId;

  const CommentsView({
    super.key,
    required this.postId,
    required this.currentUserId,
  });

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<CommentCubit>();
      cubit.getComments(widget.postId);
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
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // comments header 
          Column(
            children: [
              // Handle Bar
              Container(
                width: 45,
                height: 5,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              // Title - Localized
              Text(l10n.commentsTitle, style: Styles.textStyle20),
              const SizedBox(height: 5),
            ],
          ),
          const Divider(height: 1),
          // comments list
          Expanded(
            child: CommentsBlocConsumer(currentUserId: widget.currentUserId),
          ),
          // comment input field
          InputFieldBlocBuilder(
            controller: _controller,
            focusNode: _focusNode,
            postId: widget.postId,
          ),
        ],
      ),
    );
  }
}
