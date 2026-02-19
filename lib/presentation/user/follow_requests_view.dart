import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FollowRequestsView extends StatelessWidget {
  const FollowRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.followRequests, 
          style: Styles.textStyle20, 
        ),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 2),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            l10n.noFollowRequests,
            style: Styles.textStyle20.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}