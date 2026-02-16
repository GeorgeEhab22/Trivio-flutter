import 'package:auth/presentation/chats/messages_screen/widgets/messages_item.dart';
import 'package:auth/presentation/chats/messages_screen/widgets/messages_loading_indicator.dart';
import 'package:auth/presentation/chats/messages_screen/widgets/messages_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/l10n/app_localizations.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.messages, 
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
        ),
        centerTitle: false, 
        actions: [
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.home_outlined,
              size: 30,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const MessagesSearchBar(),
          Expanded(
            child: ListView.builder(
              itemCount: 11,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                if (index == 10) {
                  return const MessagesLoadingIndicator();
                }
                return MessagesItem(index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}