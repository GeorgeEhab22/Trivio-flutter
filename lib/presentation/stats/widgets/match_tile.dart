import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/data/models/stats_dart/matches.dart';
import 'package:auth/presentation/stats/widgets/custom_team_row.dart';
import 'package:auth/presentation/stats/widgets/notification_button.dart';
import 'package:flutter/material.dart';

class MatchTile extends StatelessWidget {
  final Matches match;

  const MatchTile({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    bool? homeWon;
    if (match.score?.winner == 'HOME_TEAM') {
      homeWon = true;
    } else if (match.score?.winner == 'AWAY_TEAM') {
      homeWon = false;
    } else if (match.score?.winner == null) {
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
              SizedBox(
                width: 75,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                   Theme.of(context).iconTheme.color ?? Colors.black, 
                    BlendMode.srcIn,
                  ),
                  child: match.competition?.emblem != null
                      ? Image.network(
                          match.competition!.emblem!,
                          height: 30,
                          width: 30,
                          fit: BoxFit.contain,
                        )
                      : Icon(
                          Icons.sports_soccer,
                          color: Theme.of(context).iconTheme.color,
                          size: 30,
                        ),
                ),
              ),
              Text("Soccer ", style: Styles.textStyle15),
              Text(
                '‣ ${match.area?.name} ‣ ${match.competition?.name}',
                style: Styles.textStyle14.copyWith(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withValues(alpha: 0.4),
                ),
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
                          match.utcDate != null
                              ? "${DateTime.parse(match.utcDate!).hour.toString().padLeft(2, '0')}:${DateTime.parse(match.utcDate!).minute.toString().padLeft(2, '0')}"
                              : "TBD",
                          style: Styles.textStyle14.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.7),
                          ),
                        ),
                        // Text(
                        //   match.status,
                        //   style: TextStyle(
                        //     color: Theme.of(context).textTheme.bodyMedium?.color
                        //         ?.withValues(alpha: 0.7),
                        //     fontSize: 12,
                        //   ),
                        // ),
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
                        match.homeTeam?.crest != null
                            ? Image.network(
                                match.homeTeam!.crest!,
                                height: 30,
                                width: 30,
                                fit: BoxFit.contain,
                              )
                            : Icon(
                                Icons.sports_soccer,
                                color: Theme.of(context).iconTheme.color,
                              ),
                        match.homeTeam?.shortName?.isNotEmpty == true
                            ? match.homeTeam!.shortName!
                            : match.homeTeam?.name ?? "Home Team",
                        match.score?.fullTime?.home ?? 0,
                        homeWon == true,
                      ),
                      CustomTeamRow(
                        match.awayTeam?.crest != null
                            ? Image.network(
                                match.awayTeam!.crest!,
                                height: 30,
                                width: 30,
                                fit: BoxFit.contain,
                              )
                            : Icon(
                                Icons.sports_soccer,
                                color: Theme.of(context).iconTheme.color,
                              ),
                        match.awayTeam?.shortName?.isNotEmpty == true
                            ? match.awayTeam!.shortName!
                            : match.awayTeam?.name ?? "Away Team",
                        match.score?.fullTime?.away ?? 0,
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
