import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ReportedPostsView extends StatelessWidget {
  const ReportedPostsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportedPosts)),
      body: const Column(
        //TODO return reported post
      ),
    );
  }
}