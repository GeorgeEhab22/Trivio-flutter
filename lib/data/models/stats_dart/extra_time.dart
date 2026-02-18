
class ExtraTime {
	final int? home;
	final int? away;

	const ExtraTime({this.home, this.away});

	@override
	String toString() => 'ExtraTime(home: $home, away: $away)';

	factory ExtraTime.fromMap(Map<String, dynamic> data) => ExtraTime(
				home: data['home'] as int?,
				away: data['away'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'home': home,
				'away': away,
			};

  

	ExtraTime copyWith({
		int? home,
		int? away,
	}) {
		return ExtraTime(
			home: home ?? this.home,
			away: away ?? this.away,
		);
	}
}
