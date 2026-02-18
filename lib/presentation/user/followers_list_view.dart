import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FollowersListView extends StatelessWidget {
  const FollowersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.followers, 
          style: Styles.textStyle20,
        ),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 2),
        ),
      ),
      body: Center(
        child: Text(
          l10n.noFollowersYet, 
          style: Styles.textStyle18.copyWith(color: AppColors.darkGrey),
        ),
      ),
    );
  }
}