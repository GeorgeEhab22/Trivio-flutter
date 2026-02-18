
import 'extra_time.dart';
import 'full_time.dart';
import 'half_time.dart';
import 'penalties.dart';
import 'regular_time.dart';


class Score {
	final String? winner;
	final String? duration;
	final FullTime? fullTime;
	final HalfTime? halfTime;
	final RegularTime? regularTime;
	final ExtraTime? extraTime;
	final Penalties? penalties;

	const Score({
		this.winner, 
		this.duration, 
		this.fullTime, 
		this.halfTime, 
		this.regularTime, 
		this.extraTime, 
		this.penalties, 
	});

	@override
	String toString() {
		return 'Score(winner: $winner, duration: $duration, fullTime: $fullTime, halfTime: $halfTime, regularTime: $regularTime, extraTime: $extraTime, penalties: $penalties)';
	}

	factory Score.fromMap(Map<String, dynamic> data) => Score(
				winner: data['winner'] as String?,
				duration: data['duration'] as String?,
				fullTime: data['fullTime'] == null
						? null
						: FullTime.fromMap(data['fullTime'] as Map<String, dynamic>),
				halfTime: data['halfTime'] == null
						? null
						: HalfTime.fromMap(data['halfTime'] as Map<String, dynamic>),
				regularTime: data['regularTime'] == null
						? null
						: RegularTime.fromMap(data['regularTime'] as Map<String, dynamic>),
				extraTime: data['extraTime'] == null
						? null
						: ExtraTime.fromMap(data['extraTime'] as Map<String, dynamic>),
				penalties: data['penalties'] == null
						? null
						: Penalties.fromMap(data['penalties'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'winner': winner,
				'duration': duration,
				'fullTime': fullTime?.toMap(),
				'halfTime': halfTime?.toMap(),
				'regularTime': regularTime?.toMap(),
				'extraTime': extraTime?.toMap(),
				'penalties': penalties?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Score].
	

	Score copyWith({
		String? winner,
		String? duration,
		FullTime? fullTime,
		HalfTime? halfTime,
		RegularTime? regularTime,
		ExtraTime? extraTime,
		Penalties? penalties,
	}) {
		return Score(
			winner: winner ?? this.winner,
			duration: duration ?? this.duration,
			fullTime: fullTime ?? this.fullTime,
			halfTime: halfTime ?? this.halfTime,
			regularTime: regularTime ?? this.regularTime,
			extraTime: extraTime ?? this.extraTime,
			penalties: penalties ?? this.penalties,
		);
	}


}
