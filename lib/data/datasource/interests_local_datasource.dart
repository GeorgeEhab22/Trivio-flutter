import 'package:hive_flutter/hive_flutter.dart';

class InterestsLocalDataSource {
  static const String _boxName = 'interests_cache_box';
  static const String _playersKey = 'cached_players';
  static const String _searchPrefix = 'search_';
  
  static const String _playersTimeKey = 'players_last_fetch';

  Future<void> init() async => await Hive.openBox(_boxName);

  Box get _box => Hive.box(_boxName);

  // --- Players Cache ---
  Future<void> savePlayers(List<dynamic> players) async {
    await _box.put(_playersKey, players);
    await _box.put(_playersTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  List<Map<String, dynamic>>? getCachedPlayers() => _getAndCastList(_playersKey);
  DateTime? getPlayersLastFetchTime() => _getTime(_playersTimeKey);

  // --- Search Cache ---
  Future<void> saveSearchResults(String query, List<dynamic> players) async {
    final cleanQuery = query.toLowerCase().trim();
    await _box.put('$_searchPrefix$cleanQuery', players);
    await _box.put('$_searchPrefix${cleanQuery}_time', DateTime.now().millisecondsSinceEpoch);
  }

  List<Map<String, dynamic>>? getCachedSearchResults(String query) {
    final cleanQuery = query.toLowerCase().trim();
    return _getAndCastList('$_searchPrefix$cleanQuery');
  }

  DateTime? getSearchLastFetchTime(String query) {
    final cleanQuery = query.toLowerCase().trim();
    return _getTime('$_searchPrefix${cleanQuery}_time');
  }

  // --- Helper Methods ---
  DateTime? _getTime(String key) {
    final ms = _box.get(key);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }

  List<Map<String, dynamic>>? _getAndCastList(String key) {
    final rawData = _box.get(key);
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
      if (value is Map) return MapEntry(stringKey, _deepCastMap(value));
      if (value is List) {
        return MapEntry(stringKey, value.map((v) => v is Map ? _deepCastMap(v) : v).toList());
      }
      return MapEntry(stringKey, value);
    });
  }
}