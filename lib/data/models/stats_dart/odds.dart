

class Odds {
	final String? msg;

	const Odds({this.msg});

	@override
	String toString() => 'Odds(msg: $msg)';

	factory Odds.fromMap(Map<String, dynamic> data) => Odds(
				msg: data['msg'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'msg': msg,
			};


	Odds copyWith({
		String? msg,
	}) {
		return Odds(
			msg: msg ?? this.msg,
		);
	}

}
