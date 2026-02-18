import 'package:hive_flutter/hive_flutter.dart';

class StatsLocalDatasource {
  static const String _boxName = 'stats_cache_box';
  static const String _matchesKey = 'cached_matches';
  static const String _timeKey = 'last_fetch_timestamp';

  Future<void> init() async => await Hive.openBox(_boxName);

  Box get _box => Hive.box(_boxName);

  Future<void> saveMatches(List<dynamic> matches) async {
    await _box.put(_matchesKey, matches);
    await _box.put(_timeKey, DateTime.now().millisecondsSinceEpoch);
  }

  List<Map<String, dynamic>>? getCachedMatches() {
    final rawData = _box.get(_matchesKey);
    
    if (rawData == null || rawData is! List) return null;

    try {
      return rawData.map((item) => _deepCastMap(item)).toList();
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _deepCastMap(dynamic item) {
    if (item is! Map) return {};

    return item.map((key, value) {
      final String stringKey = key.toString();
      
      if (value is Map) {
        return MapEntry(stringKey, _deepCastMap(value));
      }
      if (value is List) {
        return MapEntry(
          stringKey, 
          value.map((v) => v is Map ? _deepCastMap(v) : v).toList()
        );
      }
      
      return MapEntry(stringKey, value);
    });
  }

  DateTime? getLastFetchTime() {
    final ms = _box.get(_timeKey);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }
}