import 'package:auth/presentation/manager/chat_cubit/chat_messages_cubit.dart';
import 'package:auth/presentation/manager/chat_cubit/chat_messages_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/chat_app_bar.dart';

class ChatView extends StatelessWidget {
  final String conversationId;
  final String targetUserId;
  final String targetUserName;
  const ChatView({
    super.key,
    required this.conversationId,
    required this.targetUserId,
    required this.targetUserName,
  });

  @override
  Widget build(BuildContext context) {
    final profileState = context.read<ProfileCubit>().state;
    String currentUserId = '';

    if (profileState is ProfileLoaded) {
      currentUserId = profileState.user.id;
    }
    return Scaffold(
      appBar: ChatAppBar( targetUserId: targetUserId, conversationId: conversationId, targetUserName: targetUserName),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
              builder: (context, state) {
                if (state is ChatMessagesLoaded) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0,),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        return ChatBubble(
                          isMe: msg.senderId ==currentUserId,
                          message: msg.text,
                          isSeen: msg.isSeen,
                          time: msg.createdAt.toLocal().toString().substring(11, 16),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          ChatInputField(currentUserId: currentUserId), 
        ],
      ),
    );
  }
}
