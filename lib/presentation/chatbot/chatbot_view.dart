import 'package:auth/injection_container.dart';

import 'package:auth/presentation/chatbot/chat_screen.dart';

import 'package:auth/presentation/manager/chatbot_cubit/chatbot_cubit.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBotPage extends StatelessWidget {
  const ChatBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: BlocProvider(
        create: (_) {
          try {
            return sl<ChatCubit>()..loadHistory();
          } catch (e) {
            rethrow;
          }
        },

        child: const ChatScreen(),
      ),
    );
  }
}
