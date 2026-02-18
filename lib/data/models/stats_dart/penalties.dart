
class Penalties {
	final int? home;
	final int? away;

	const Penalties({this.home, this.away});

	@override
	String toString() => 'Penalties(home: $home, away: $away)';

	factory Penalties.fromMap(Map<String, dynamic> data) => Penalties(
				home: data['home'] as int?,
				away: data['away'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'home': home,
				'away': away,
			};

 

	Penalties copyWith({
		int? home,
		int? away,
	}) {
		return Penalties(
			home: home ?? this.home,
			away: away ?? this.away,
		);
	}
}
