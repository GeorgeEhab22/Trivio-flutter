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
}
