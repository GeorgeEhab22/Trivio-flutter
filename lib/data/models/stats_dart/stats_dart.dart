
import 'package:flutter/foundation.dart';

import 'filters.dart';
import 'matches.dart';
import 'result_set.dart';

@immutable
class StatsDart {
  final Filters? filters;
  final ResultSet? resultSet;
  final List<Matches>? matches;

  const StatsDart({this.filters, this.resultSet, this.matches});

  @override
  String toString() {
    return 'StatsDart(filters: $filters, resultSet: $resultSet, matches: $matches)';
  }

  factory StatsDart.fromMap(Map<String, dynamic> data) => StatsDart(
    filters: data['filters'] == null
        ? null
        : Filters.fromMap(data['filters'] as Map<String, dynamic>),
    resultSet: data['resultSet'] == null
        ? null
        : ResultSet.fromMap(data['resultSet'] as Map<String, dynamic>),
    matches: (data['matches'] as List<dynamic>?)
        ?.map((e) => Matches.fromMap(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toMap() => {
    'filters': filters?.toMap(),
    'resultSet': resultSet?.toMap(),
    'matches': matches?.map((e) => e.toMap()).toList(),
  };



  StatsDart copyWith({
    Filters? filters,
    ResultSet? resultSet,
    List<Matches>? matches,
  }) {
    return StatsDart(
      filters: filters ?? this.filters,
      resultSet: resultSet ?? this.resultSet,
      matches: matches ?? this.matches,
    );
  }
}
