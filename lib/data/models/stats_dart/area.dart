
class Area {
	final int? id;
	final String? name;
	final String? code;
	final String? flag;

	const Area({this.id, this.name, this.code, this.flag});

	@override
	String toString() {
		return 'Area(id: $id, name: $name, code: $code, flag: $flag)';
	}

	factory Area.fromMap(Map<String, dynamic> data) => Area(
				id: data['id'] as int?,
				name: data['name'] as String?,
				code: data['code'] as String?,
				flag: data['flag'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
				'code': code,
				'flag': flag,
			};

  

	Area copyWith({
		int? id,
		String? name,
		String? code,
		String? flag,
	}) {
		return Area(
			id: id ?? this.id,
			name: name ?? this.name,
			code: code ?? this.code,
			flag: flag ?? this.flag,
		);
	}
}
