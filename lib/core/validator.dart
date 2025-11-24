import 'package:auth/constants/regex_patterns.dart';

class Validator {

   static bool isValidPassword( String password) {
    return RegexPatterns.passwordRegex.hasMatch(password);
  }
  static bool isValidEmail(String email) {
    return RegexPatterns.emailRegex.hasMatch(email);
  }
  static bool isValidUsername(String username) {
    return RegexPatterns.usernameRegex.hasMatch(username);
  }
  static bool isValidUrl(String url) {
    return RegexPatterns.urlRegex.hasMatch(url);
  }
  static bool isValidId(String id) {
      if (id.trim().isEmpty) return false;
    return RegexPatterns.idRegex.hasMatch(id);
}
}
