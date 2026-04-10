import 'package:auth/presentation/chatbot/widgets/chat_input_bar.dart';
import 'package:auth/presentation/chatbot/widgets/chatbot_bubble.dart';
import 'package:auth/presentation/chatbot/widgets/gradient_background.dart';
import 'package:auth/presentation/chatbot/widgets/typing_indicator.dart';
import 'package:auth/presentation/manager/chatbot_cubit/chatbot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<ChatCubit>().sendMessage(text);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            const GradientBackground(),
            Column(
              children: [
                Expanded(
                  child: BlocConsumer<ChatCubit, ChatState>(
                    listener: (context, state) {
                      if (state is ChatLoaded || state is ChatLoading) {
                        _scrollToBottom();
                      }

                      if (state is ChatError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: const Color(0xFFFF4444),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    builder: (context, state) => switch (state) {
                      ChatInitial() => const _FullScreenLoader(),

                      ChatLoading(:final messages) when messages.isEmpty =>
                        const _FullScreenLoader(),

                      ChatLoading(:final messages) => _MessageList(
                          messages: messages,
                          isLoading: true,
                          scrollController: _scrollController,
                        ),

                      ChatLoaded(:final messages) => _MessageList(
                          messages: messages,
                          isLoading: false,
                          scrollController: _scrollController,
                        ),

                      ChatError(:final message) => _ErrorView(
                          message: message,
                          onRetry: () =>
                              context.read<ChatCubit>().loadHistory(),
                        ),
                    },
                  ),
                ),
                BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    final enabled = state is ChatLoaded || state is ChatLoading;
                    return ChatInputBar(
                      controller: _controller,
                      onSend: enabled ? _sendMessage : () {},
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AppBar(
            backgroundColor: const Color(0xFF131313).withValues(alpha: 0.7),
            elevation: 0,
            centerTitle: false,
            title: const Row(
              children: [
                Icon(Icons.sports_soccer, color: Color(0xFF00E639)),
                SizedBox(width: 8),
                Text(
                  'TRIVIO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: -1,
                    color: Color(0xFF00E639),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline, color: Color(0xFF00E639)),
                onPressed: () {},
                tooltip: isArabic ? 'حول' : 'About',
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Message list ─────────────────────────────

class _MessageList extends StatelessWidget {
  final List messages;
  final bool isLoading;
  final ScrollController scrollController;

  const _MessageList({
    required this.messages,
    required this.isLoading,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = messages.length + (isLoading ? 1 : 0);

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(
        top: 100,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == messages.length && isLoading) {
          return const TypingIndicator();
        }
        return ChatbotBubble(
          key: ValueKey(messages[index].createdAt),
          message: messages[index],
        );
      },
    );
  }
}

// ── Full screen loader (initial history fetch) ────────

class _FullScreenLoader extends StatelessWidget {
  const _FullScreenLoader();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF00E639),
        strokeWidth: 2,
      ),
    );
  }
}

// ── Error view with retry ─────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFFF4444), size: 32),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: Color(0xFF00E639)),
              label: const Text(
                'Retry',
                style: TextStyle(color: Color(0xFF00E639)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}