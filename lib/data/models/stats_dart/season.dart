
class Season {
  final int? id;
  final String? startDate;
  final String? endDate;
  final int? currentMatchday;
  final dynamic winner;

  const Season({
    this.id,
    this.startDate,
    this.endDate,
    this.currentMatchday,
    this.winner,
  });

  @override
  String toString() {
    return 'Season(id: $id, startDate: $startDate, endDate: $endDate, currentMatchday: $currentMatchday, winner: $winner)';
  }

  factory Season.fromMap(Map<String, dynamic> data) => Season(
    id: data['id'] as int?,
    startDate: data['startDate'] as String?,
    endDate: data['endDate'] as String?,
    currentMatchday: data['currentMatchday'] as int?,
    winner: data['winner'] as dynamic,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'startDate': startDate,
    'endDate': endDate,
    'currentMatchday': currentMatchday,
    'winner': winner,
  };


  Season copyWith({
    int? id,
    String? startDate,
    String? endDate,
    int? currentMatchday,
    dynamic winner,
  }) {
    return Season(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentMatchday: currentMatchday ?? this.currentMatchday,
      winner: winner ?? this.winner,
    );
  }
}
