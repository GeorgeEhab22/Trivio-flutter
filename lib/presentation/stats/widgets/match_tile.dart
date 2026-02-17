import 'package:auth/common/functions/match_status_helper.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/data/models/stats_dart/matches.dart';
import 'package:auth/presentation/stats/widgets/custom_team_row.dart';
import 'package:auth/presentation/stats/widgets/notification_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
// Ensure this import path is correct for your project
import 'package:auth/common/functions/football_mapper.dart';

class MatchTile extends StatelessWidget {
  final Matches match;

  const MatchTile({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final bool hasStarted =
        match.status != 'SCHEDULED' &&
        match.status != 'TIMED' &&
        match.status != 'CANCELLED';

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: match.competition?.emblem != null
                      ? Image.network(
                          match.competition!.emblem!,
                          height: 40,
                          width: 40,
                          fit: BoxFit.contain,
                        )
                      : Icon(
                          Icons.sports_soccer,
                          color: Theme.of(context).iconTheme.color,
                          size: 28,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Skeleton.ignore(
                    child: Text(
                      isArabic
                          ? '‣ ${FootballMapper.translate(match.area?.name)} ‣ ${FootballMapper.translate(match.competition?.name)}'
                          : '‣ ${match.area?.name ?? ''} ‣ ${match.competition?.name ?? ''}',
                      style: Styles.textStyle16.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          match.utcDate != null
                              ? DateFormat('HH:mm').format(
                                  DateTime.parse(match.utcDate!).toLocal(),
                                )
                              : "TBD",
                          style: Styles.textStyle14.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Skeleton.ignore(
                          child: PremiumMatchStatusBadge(
                            status: match.status.toString(),

                            animate: true,
                            compact: false,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 1,
                    height: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    color: AppColors.customGrey,
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        CustomTeamRow(
                          _buildCrest(match.homeTeam?.crest, context),
                          isArabic
                              ? FootballMapper.translate(match.homeTeam?.name)
                              : match.homeTeam?.shortName ?? '',
                          hasStarted
                              ? (match.score?.fullTime?.home ?? 0)
                              : null,
                          isHomeWinner,
                        ),
                        const SizedBox(height: 12),
                        CustomTeamRow(
                          _buildCrest(match.awayTeam?.crest, context),
                          isArabic
                              ? FootballMapper.translate(match.awayTeam?.name)
                              : match.awayTeam?.shortName ?? '',
                          hasStarted
                              ? (match.score?.fullTime?.away ?? 0)
                              : null,
                          isAwayWinner,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 1,
                    height: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: AppColors.customGrey,
                  ),

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
      height: 36,
      width: 36,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: url != null
            ? Image.network(
                url,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.sports_soccer,
                  size: 16,
                  color: Colors.grey,
                ),
              )
            : Opacity(
                opacity: 0.3,
                child: Icon(
                  Icons.sports_soccer_outlined,
                  color: Theme.of(context).iconTheme.color,
                  size: 20,
                ),
              ),
      ),
    );
  }
}
