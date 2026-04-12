class DateParser {
  static DateTime parseDateCorrectly(dynamic rawDate) {
    if (rawDate == null) return DateTime.now();
    
    String str = rawDate.toString();
    
    str = str.replaceAll(' ', 'T');
    
    if (!str.endsWith('Z') && !str.contains('+')) {
      str = '${str}Z';
    }
    
    try {
      return DateTime.parse(str).toLocal();
    } catch (e) {
      return DateTime.now();
    }
  }
}