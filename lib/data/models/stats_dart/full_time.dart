
class FullTime {
	final int? home;
	final int? away;

	const FullTime({this.home, this.away});

	@override
	String toString() => 'FullTime(home: $home, away: $away)';

	factory FullTime.fromMap(Map<String, dynamic> data) => FullTime(
				home: data['home'] as int?,
				away: data['away'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'home': home,
				'away': away,
			};

 

	FullTime copyWith({
		int? home,
		int? away,
	}) {
		return FullTime(
			home: home ?? this.home,
			away: away ?? this.away,
		);
	}

}
