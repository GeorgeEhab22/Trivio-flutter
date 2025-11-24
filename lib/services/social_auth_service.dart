import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthService {
  late final GoogleSignIn _googleSignIn;
  SocialAuthService() {
    if (kIsWeb) {
      _googleSignIn = GoogleSignIn(
        clientId:
            '611128611061-5vdn62kub0kt6hv1vp6bp1rth7ktar73.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
      );
    } else if (kIsWeb != true) {
      _googleSignIn = GoogleSignIn(
        serverClientId:
            '611128611061-5vdn62kub0kt6hv1vp6bp1rth7ktar73.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
      );
    }
  }
  Future<String?> getGoogleIdToken() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();

      if (account == null) {
        return null;
      }
      final auth = await account.authentication;
      return auth.idToken;
    } catch (e) {
      return null;
    }
  }

  Future<void> googleSignInHandler(VoidCallback onSignedIn) async {
    try {
      //  final currentUser = _googleSignIn.currentUser;
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.signOut();
      }
      try {
        await _googleSignIn.disconnect();
      } catch (_) {}
      final account = await _googleSignIn.signIn();
      if (account != null) {
        onSignedIn();
      }
    } catch (e) {
      rethrow;
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
