
class Referee {
	final int? id;
	final String? name;
	final String? type;
	final String? nationality;

	const Referee({this.id, this.name, this.type, this.nationality});

	@override
	String toString() {
		return 'Referee(id: $id, name: $name, type: $type, nationality: $nationality)';
	}

	factory Referee.fromMap(Map<String, dynamic> data) => Referee(
				id: data['id'] as int?,
				name: data['name'] as String?,
				type: data['type'] as String?,
				nationality: data['nationality'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
				'type': type,
				'nationality': nationality,
			};

  

	Referee copyWith({
		int? id,
		String? name,
		String? type,
		String? nationality,
	}) {
		return Referee(
			id: id ?? this.id,
			name: name ?? this.name,
			type: type ?? this.type,
			nationality: nationality ?? this.nationality,
		);
	}


}
