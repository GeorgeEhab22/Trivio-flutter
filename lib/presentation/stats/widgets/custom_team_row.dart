// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';

class CustomTeamRow extends StatelessWidget {
  final Widget icon;
  final String name;
  final int score;
  final bool? winner;

  const CustomTeamRow(this.icon, this.name, this.score, this.winner);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 5,  child: winner == true
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.1,
                      child: Opacity(
                        opacity: 0.3,
                        child: icon,
                      ),
                    ),
                    icon,
                  ],
                )
              : icon,),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            name,
            style: Styles.textStyle16.copyWith(color: AppColors.lightGrey, fontWeight: winner == true ? FontWeight.w600 : FontWeight.normal),
          ),
        ),
        Text(
          score.toString(),
          style: Styles.textStyle16.copyWith(
            color: AppColors.lightGrey,
            fontWeight: winner == true ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
