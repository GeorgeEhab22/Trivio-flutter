import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/data/models/stats_dart/matches.dart';
import 'package:auth/presentation/stats/widgets/custom_team_row.dart';
import 'package:auth/presentation/stats/widgets/notification_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MatchTile extends StatelessWidget {
  final Matches match;

  const MatchTile({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final bool isHomeWinner = match.score?.winner == 'HOME_TEAM';
    final bool isAwayWinner = match.score?.winner == 'AWAY_TEAM';

    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.lightGrey, width: 1),
          bottom: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 65,
                child: match.competition?.emblem != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Image.network(
                          match.competition!.emblem!,
                          height: 45,
                          width: 45,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Icon(
                        Icons.sports_soccer,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      ),
              ),
              const SizedBox(width: 16),
              Skeleton.ignore(
                child: Text(
                  '‣ ${match.area?.name ?? ""} ‣ ${match.competition?.name ?? ""}',
                  style: Styles.textStyle16.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Center(
                      child: Text(
                        match.utcDate != null
                            ? DateFormat('hh:mm').format(DateTime.parse(match.utcDate!).toLocal())
                            : "TBD",
                        style: Styles.textStyle16,
                      ),
                    ),
                  ),

                  const VerticalDivider(
                    width: 32,
                    color: AppColors.customGrey,
                    thickness: 1,
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        CustomTeamRow(
                          _buildCrest(match.homeTeam?.crest, context),
                          match.homeTeam?.shortName ??
                              match.homeTeam?.name ??
                              "Home",
                          match.score?.fullTime?.home ?? 0,
                          isHomeWinner,
                        ),
                        const SizedBox(height: 12),
                        CustomTeamRow(
                          _buildCrest(match.awayTeam?.crest, context),
                          match.awayTeam?.shortName ??
                              match.awayTeam?.name ??
                              "Away",
                          match.score?.fullTime?.away ?? 0,
                          isAwayWinner,
                        ),
                      ],
                    ),
                  ),

                  const VerticalDivider(
                    width: 20,
                    color: AppColors.customGrey,
                    thickness: 1,
                  ),

                  // 3. Action
                  Skeleton.ignore(child: const NotificationButton()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrest(String? url, BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
      child: ClipOval(
        child: url != null
            ? Image.network(
                url,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.sports_soccer,
                  size: 18,
                  color: Colors.grey,
                ),
              )
            : Opacity(
                opacity: 0.3,
                child: Icon(
                  Icons.sports_soccer_outlined,
                  color: Theme.of(context).iconTheme.color,
                  size: 24,
                ),
              ),
      ),
    );
  }
}
