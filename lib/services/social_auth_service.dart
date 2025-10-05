import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

class SocialAuthService {
  late final GoogleSignIn _googleSignIn;

  SocialAuthService() {
    if (kIsWeb) {
      _googleSignIn = GoogleSignIn(
        clientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
      );
    } else {
      _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
    }
  }

  Future<String?> getGoogleIdToken() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;
      final auth = await account.authentication;
      return auth.idToken;
    } catch (e, s) {
      if (kDebugMode) {
        print('Google sign-in failed: $e\n$s');
      }
      return null;
    }
  }

  Future<Map<String, String>?> getAppleCredentials() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    if (credential.identityToken == null) return null;
    return {
      'identityToken': credential.identityToken!,
      'authorizationCode': credential.authorizationCode,
    };
  }
}
