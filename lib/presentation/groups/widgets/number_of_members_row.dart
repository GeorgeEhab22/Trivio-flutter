import 'package:auth/common/functions/format_number.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class NumberOfMembersRow extends StatelessWidget {
  const NumberOfMembersRow({super.key});

  @override
  Widget build(BuildContext context) {
    final int numOfMembers = 50040000;
    return Text(
      "${formatNumber(numOfMembers)} members",
      style: Styles.textStyle14.copyWith(color: Colors.grey),
    );
  }
}
