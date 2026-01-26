import 'package:auth/core/styels.dart';
import 'package:auth/presentation/stats/widgets/match_item_class.dart';
import 'package:auth/presentation/stats/widgets/match_tile.dart';
import 'package:flutter/material.dart';

class StatsScreenView extends StatelessWidget {
  const StatsScreenView({super.key});

  //dummy items
  static const List<MatchItem> matches = [
    MatchItem(
      leagueIcon: Icon(Icons.sports_soccer, color: Colors.black),
      league: 'Premier League',
      country: 'England',
      time: '4:00 PM',
      status: 'FT',
      homeTeamIcon: Icon(Icons.ice_skating, color: Colors.red),
      awayTeamIcon: Icon(Icons.accessibility_new_outlined, color: Colors.blue),
      homeTeam: 'Wolves',
      awayTeam: 'Newcastle',
      homeScore: 0,
      awayScore: 0,
    ),
    MatchItem(
      leagueIcon: Icon(Icons.sports_soccer, color: Colors.black),
      league: 'LaLiga',
      country: 'Spain',
      time: '5:15 PM',
      status: 'FT',
      homeTeamIcon: Icon(Icons.shield, color: Colors.red),
      awayTeamIcon: Icon(Icons.shield, color: Colors.blue),
      homeTeam: 'Atl. Madrid',
      awayTeam: 'Alavés',
      homeScore: 1,
      awayScore: 0,
    ),
    MatchItem(
      leagueIcon: Icon(Icons.sports_soccer, color: Colors.black),
      league: 'Serie A',
      country: 'Italy',
      time: '7:00 PM',
      status: 'FT',
      homeTeamIcon: Icon(Icons.face_2_rounded, color: Colors.red),
      awayTeamIcon: Icon(Icons.kayaking, color: Colors.blue),
      homeTeam: 'Torino',
      awayTeam: 'Roma',
      homeScore: 0,
      awayScore: 2,
    ),
    MatchItem(
      leagueIcon: Icon(Icons.sports_soccer, color: Colors.black),
      league: 'LaLiga',
      country: 'Spain',
      time: '5:15 PM',
      status: 'FT',
      homeTeamIcon: Icon(Icons.vaccines, color: Colors.red),
      awayTeamIcon: Icon(Icons.umbrella, color: Colors.blue),
      homeTeam: 'Atl. Madrid',
      awayTeam: 'Alavés',
      homeScore: 1,
      awayScore: 0,
    ),
    MatchItem(
      leagueIcon: Icon(Icons.sports_soccer, color: Colors.black),
      league: 'Serie A',
      country: 'Italy',
      time: '7:00 PM',
      status: 'FT',
      homeTeamIcon: Icon(Icons.shield, color: Colors.red),
      awayTeamIcon: Icon(Icons.shield, color: Colors.blue),
      homeTeam: 'Torino',
      awayTeam: 'Roma',
      homeScore: 0,
      awayScore: 2,
    ),
    MatchItem(
      leagueIcon: Icon(Icons.sports_soccer, color: Colors.black),
      league: 'LaLiga',
      country: 'Spain',
      time: '5:15 PM',
      status: 'FT',
      homeTeamIcon: Icon(Icons.shield, color: Colors.red),
      awayTeamIcon: Icon(Icons.shield, color: Colors.blue),
      homeTeam: 'Atl. Madrid',
      awayTeam: 'Alavés',
      homeScore: 1,
      awayScore: 0,
    ),
    MatchItem(
      leagueIcon: Icon(Icons.sports_soccer, color: Colors.black),
      league: 'Serie A',
      country: 'Italy',
      time: '7:00 PM',
      status: 'FT',
      homeTeamIcon: Icon(Icons.shield, color: Colors.red),
      awayTeamIcon: Icon(Icons.shield, color: Colors.blue),
      homeTeam: 'Torino',
      awayTeam: 'Roma',
      homeScore: 0,
      awayScore: 2,
    ),
    MatchItem(
      leagueIcon: Icon(Icons.sports_soccer, color: Colors.black),
      league: 'LaLiga',
      country: 'Spain',
      time: '5:15 PM',
      status: 'FT',
      homeTeamIcon: Icon(Icons.shield, color: Colors.red),
      awayTeamIcon: Icon(Icons.shield, color: Colors.blue),
      homeTeam: 'Atl. Madrid',
      awayTeam: 'Alavés',
      homeScore: 1,
      awayScore: 0,
    ),
    MatchItem(
      leagueIcon: Icon(Icons.sports_soccer, color: Colors.black),
      league: 'Serie A',
      country: 'Italy',
      time: '7:00 PM',
      status: 'FT',
      homeTeamIcon: Icon(Icons.shield, color: Colors.red),
      awayTeamIcon: Icon(Icons.shield, color: Colors.blue),
      homeTeam: 'Torino',
      awayTeam: 'Roma',
      homeScore: 0,
      awayScore: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text("Stats", style: Styles.textStyle30),
      ),
      body: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          return MatchTile(match: matches[index]);
        },
      ),
    );
  }
}
