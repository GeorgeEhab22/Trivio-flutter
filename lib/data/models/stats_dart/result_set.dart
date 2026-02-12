

class ResultSet {
	final int? count;
	final String? competitions;
	final String? first;
	final String? last;
	final int? played;

	const ResultSet({
		this.count, 
		this.competitions, 
		this.first, 
		this.last, 
		this.played, 
	});

	@override
	String toString() {
		return 'ResultSet(count: $count, competitions: $competitions, first: $first, last: $last, played: $played)';
	}

	factory ResultSet.fromMap(Map<String, dynamic> data) => ResultSet(
				count: data['count'] as int?,
				competitions: data['competitions'] as String?,
				first: data['first'] as String?,
				last: data['last'] as String?,
				played: data['played'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'count': count,
				'competitions': competitions,
				'first': first,
				'last': last,
				'played': played,
			};



	ResultSet copyWith({
		int? count,
		String? competitions,
		String? first,
		String? last,
		int? played,
	}) {
		return ResultSet(
			count: count ?? this.count,
			competitions: competitions ?? this.competitions,
			first: first ?? this.first,
			last: last ?? this.last,
			played: played ?? this.played,
		);
	}
}
