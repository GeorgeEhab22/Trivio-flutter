import 'dart:io';

import 'package:auth/constants/regex_patterns.dart';

class Validator {
  static bool isValidPassword(String password) {
    return RegexPatterns.passwordRegex.hasMatch(password);
  }

  static bool isValidEmail(String email) {
    return RegexPatterns.emailRegex.hasMatch(email);
  }

  static bool isValidUsername(String username) {
    return RegexPatterns.usernameRegex.hasMatch(username);
  }

  static bool validatePickedImage(File? file) {
    if (file == null) return false;
    if (!file.existsSync()) return false;
    final ext = file.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) return false;
    if (file.lengthSync() > 5 * 1024 * 1024) return false; // max 5MB
    return true;
  }
  static bool validatePickedVideo(File? file) {
  if (file == null) return false;
  if (!file.existsSync()) return false;

  final ext = file.path.split('.').last.toLowerCase();

  const allowedVideoExt = [
    'mp4',
    'mov',
    'avi',
    'mkv',
    'flv',
    'webm',
    'm4v',
  ];

  if (!allowedVideoExt.contains(ext)) return false;

  // Optional: max video size (example: 10MB)
  const maxSizeBytes = 10 * 1024 * 1024;
  if (file.lengthSync() > maxSizeBytes) return false;

  return true;
}


  static bool isValidId(String id) {
    if (id.trim().isEmpty) return false;
    return RegexPatterns.idRegex.hasMatch(id);
  }
}
