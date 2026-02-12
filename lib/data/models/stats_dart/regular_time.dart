
class RegularTime {
	final int? home;
	final int? away;

	const RegularTime({this.home, this.away});

	@override
	String toString() => 'RegularTime(home: $home, away: $away)';

	factory RegularTime.fromMap(Map<String, dynamic> data) => RegularTime(
				home: data['home'] as int?,
				away: data['away'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'home': home,
				'away': away,
			};


	RegularTime copyWith({
		int? home,
		int? away,
	}) {
		return RegularTime(
			home: home ?? this.home,
			away: away ?? this.away,
		);
	}

	@override
	int get hashCode => home.hashCode ^ away.hashCode;
}
