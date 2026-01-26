import 'package:flutter/widgets.dart';

class MatchItem {
  final Widget? leagueIcon;
  final String league;
  final String country;
  final String time;
  final String status;
  final Widget? homeTeamIcon;
  final String homeTeam;
  final Widget? awayTeamIcon;
  final String awayTeam;
  final int homeScore;
  final int awayScore;

  const MatchItem({
    this.leagueIcon,
    this.homeTeamIcon,
    this.awayTeamIcon,
    required this.league,
    required this.country,
    required this.time,
    required this.status,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
  });
}
