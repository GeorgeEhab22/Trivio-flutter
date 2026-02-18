
class Competition {
	final int? id;
	final String? name;
	final String? code;
	final String? type;
	final String? emblem;

	const Competition({
		this.id, 
		this.name, 
		this.code, 
		this.type, 
		this.emblem, 
	});

	@override
	String toString() {
		return 'Competition(id: $id, name: $name, code: $code, type: $type, emblem: $emblem)';
	}

	factory Competition.fromMap(Map<String, dynamic> data) => Competition(
				id: data['id'] as int?,
				name: data['name'] as String?,
				code: data['code'] as String?,
				type: data['type'] as String?,
				emblem: data['emblem'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
				'code': code,
				'type': type,
				'emblem': emblem,
			};

  

	Competition copyWith({
		int? id,
		String? name,
		String? code,
		String? type,
		String? emblem,
	}) {
		return Competition(
			id: id ?? this.id,
			name: name ?? this.name,
			code: code ?? this.code,
			type: type ?? this.type,
			emblem: emblem ?? this.emblem,
		);
	}


}
