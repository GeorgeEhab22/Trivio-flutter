import 'package:auth/common/functions/format_number.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class NumberOfMembersRow extends StatelessWidget {
  final int numOfMembers;
  const NumberOfMembersRow({super.key, required this.numOfMembers});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      "${formatNumber(numOfMembers)} ${l10n.members}",
      style: Styles.textStyle14.copyWith(color: Colors.grey),
    );
  }
}