import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/stats/widgets/custom_team_row.dart';
import 'package:auth/presentation/stats/widgets/match_item_class.dart';
import 'package:auth/presentation/stats/widgets/notification_button.dart';
import 'package:flutter/material.dart';

class MatchTile extends StatelessWidget {
  final MatchItem match;

  const MatchTile({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    bool? homeWon;
    if (match.homeScore > match.awayScore) {
      homeWon = true;
    } else if (match.awayScore > match.homeScore) {
      homeWon = false;
    }
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // League row
          Row(
            children: [
              SizedBox(width: 75, child: match.leagueIcon),
              Text("Soccer ", style: Styles.textStyle15),
              Text(
                '‣ ${match.country} ‣ ${match.league}',
                style: Styles.textStyle14.copyWith(color: AppColors.darkGrey),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Time / Status
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          match.time,
                          style: Styles.textStyle14.copyWith(
                            color: AppColors.lightGrey,
                          ),
                        ),
                        Text(
                          match.status,
                          style: const TextStyle(
                            color: AppColors.lightGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 2),
                Container(
                  width: 1,
                  height: 50,
                  color: AppColors.customGrey,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),

                // Teams
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTeamRow(
                        match.homeTeamIcon ??
                            const Icon(
                              Icons.sports_soccer,
                              color: Colors.black,
                            ),
                        match.homeTeam,
                        match.homeScore,
                        homeWon == true,
                      ),
                      CustomTeamRow(
                        match.awayTeamIcon ??
                            const Icon(
                              Icons.sports_soccer,
                              color: Colors.black,
                            ),
                        match.awayTeam,
                        match.awayScore,
                        homeWon == false,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 6),
                Container(
                  width: 1,
                  height: 50,
                  color: AppColors.customGrey,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                ),
                const NotificationButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


