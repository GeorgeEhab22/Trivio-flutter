

import 'area.dart';
import 'away_team.dart';
import 'competition.dart';
import 'home_team.dart';
import 'odds.dart';
import 'referee.dart';
import 'score.dart';
import 'season.dart';

class Matches {
	final Area? area;
	final Competition? competition;
	final Season? season;
	final int? id;
	final String? utcDate;
	final String? status;
	final int? matchday;
	final String? stage;
	final dynamic group;
	final String? lastUpdated;
	final HomeTeam? homeTeam;
	final AwayTeam? awayTeam;
	final Score? score;
	final Odds? odds;
	final List<Referee>? referees;

	const Matches({
		this.area, 
		this.competition, 
		this.season, 
		this.id, 
		this.utcDate, 
		this.status, 
		this.matchday, 
		this.stage, 
		this.group, 
		this.lastUpdated, 
		this.homeTeam, 
		this.awayTeam, 
		this.score, 
		this.odds, 
		this.referees, 
	});

	@override
	String toString() {
		return 'Match(area: $area, competition: $competition, season: $season, id: $id, utcDate: $utcDate, status: $status, matchday: $matchday, stage: $stage, group: $group, lastUpdated: $lastUpdated, homeTeam: $homeTeam, awayTeam: $awayTeam, score: $score, odds: $odds, referees: $referees)';
	}

	factory Matches.fromMap(Map<String, dynamic> data) => Matches(
				area: data['area'] == null
						? null
						: Area.fromMap(data['area'] as Map<String, dynamic>),
				competition: data['competition'] == null
						? null
						: Competition.fromMap(data['competition'] as Map<String, dynamic>),
				season: data['season'] == null
						? null
						: Season.fromMap(data['season'] as Map<String, dynamic>),
				id: data['id'] as int?,
				utcDate: data['utcDate'] as String?,
				status: data['status'] as String?,
				matchday: data['matchday'] as int?,
				stage: data['stage'] as String?,
				group: data['group'] as dynamic,
				lastUpdated: data['lastUpdated'] as String?,
				homeTeam: data['homeTeam'] == null
						? null
						: HomeTeam.fromMap(data['homeTeam'] as Map<String, dynamic>),
				awayTeam: data['awayTeam'] == null
						? null
						: AwayTeam.fromMap(data['awayTeam'] as Map<String, dynamic>),
				score: data['score'] == null
						? null
						: Score.fromMap(data['score'] as Map<String, dynamic>),
				odds: data['odds'] == null
						? null
						: Odds.fromMap(data['odds'] as Map<String, dynamic>),
				referees: (data['referees'] as List<dynamic>?)
						?.map((e) => Referee.fromMap(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toMap() => {
				'area': area?.toMap(),
				'competition': competition?.toMap(),
				'season': season?.toMap(),
				'id': id,
				'utcDate': utcDate,
				'status': status,
				'matchday': matchday,
				'stage': stage,
				'group': group,
				'lastUpdated': lastUpdated,
				'homeTeam': homeTeam?.toMap(),
				'awayTeam': awayTeam?.toMap(),
				'score': score?.toMap(),
				'odds': odds?.toMap(),
				'referees': referees?.map((e) => e.toMap()).toList(),
			};

 

	Matches copyWith({
		Area? area,
		Competition? competition,
		Season? season,
		int? id,
		String? utcDate,
		String? status,
		int? matchday,
		String? stage,
		dynamic group,
		String? lastUpdated,
		HomeTeam? homeTeam,
		AwayTeam? awayTeam,
		Score? score,
		Odds? odds,
		List<Referee>? referees,
	}) {
		return Matches(
			area: area ?? this.area,
			competition: competition ?? this.competition,
			season: season ?? this.season,
			id: id ?? this.id,
			utcDate: utcDate ?? this.utcDate,
			status: status ?? this.status,
			matchday: matchday ?? this.matchday,
			stage: stage ?? this.stage,
			group: group ?? this.group,
			lastUpdated: lastUpdated ?? this.lastUpdated,
			homeTeam: homeTeam ?? this.homeTeam,
			awayTeam: awayTeam ?? this.awayTeam,
			score: score ?? this.score,
			odds: odds ?? this.odds,
			referees: referees ?? this.referees,
		);
	}


}
