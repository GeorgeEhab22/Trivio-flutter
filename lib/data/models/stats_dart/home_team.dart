
class HomeTeam {
	final int? id;
	final String? name;
	final String? shortName;
	final String? tla;
	final String? crest;

	const HomeTeam({
		this.id, 
		this.name, 
		this.shortName, 
		this.tla, 
		this.crest, 
	});

	@override
	String toString() {
		return 'HomeTeam(id: $id, name: $name, shortName: $shortName, tla: $tla, crest: $crest)';
	}

	factory HomeTeam.fromMap(Map<String, dynamic> data) => HomeTeam(
				id: data['id'] as int?,
				name: data['name'] as String?,
				shortName: data['shortName'] as String?,
				tla: data['tla'] as String?,
				crest: data['crest'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
				'shortName': shortName,
				'tla': tla,
				'crest': crest,
			};

  
	HomeTeam copyWith({
		int? id,
		String? name,
		String? shortName,
		String? tla,
		String? crest,
	}) {
		return HomeTeam(
			id: id ?? this.id,
			name: name ?? this.name,
			shortName: shortName ?? this.shortName,
			tla: tla ?? this.tla,
			crest: crest ?? this.crest,
		);
	}


}
