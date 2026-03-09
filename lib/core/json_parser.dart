import '../../domain/entities/reaction_type.dart';

class JsonParser {
  static String? parseId(dynamic value) {
    if (value == null) return null;
    
    if (value is Map<String, dynamic>) {
      final nested = value['_id'] ?? value['id'] ?? value[r'$oid'] ?? value['userId'];
      return parseId(nested);
    }
    
    final str = value.toString().trim();
    if (str.isEmpty || str.toLowerCase() == 'null' || str.toLowerCase() == 'undefined') {
      return null;
    }
    return str;
  }

  static String parseString(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString().trim();
  }

  static int parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value == null) return 0;
    return int.tryParse(value.toString()) ?? 0;
  }



  static List<String> parseStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  static DateTime? parseDate(dynamic value, {bool isNullable = false}) {
    if (value == null) return isNullable ? null : DateTime.now();
    return DateTime.tryParse(value.toString()) ?? (isNullable ? null : DateTime.now());
  }


  static ReactionType parseReactionType(dynamic value) {
    final raw = value?.toString().toLowerCase().trim() ?? '';
    return ReactionType.values.firstWhere(
      (e) => e.name == raw, 
      orElse: () => ReactionType.none,
    );
  }

  static Map<ReactionType, int> mapReactionCounts(dynamic map) {
    if (map is! Map<String, dynamic>) return {};
    
    final counts = <ReactionType, int>{};
    for (var type in ReactionType.values) {
      if (type == ReactionType.none) continue;
      
      final count = parseInt(map[type.name]);
      if (count > 0) {
        counts[type] = count;
      }
    }
    return counts;
  }
}