
class HalfTime {
	final int? home;
	final int? away;

	const HalfTime({this.home, this.away});

	@override
	String toString() => 'HalfTime(home: $home, away: $away)';

	factory HalfTime.fromMap(Map<String, dynamic> data) => HalfTime(
				home: data['home'] as int?,
				away: data['away'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'home': home,
				'away': away,
			};

  

	HalfTime copyWith({
		int? home,
		int? away,
	}) {
		return HalfTime(
			home: home ?? this.home,
			away: away ?? this.away,
		);
	}

}
